termux_step_get_dependencies() {
	if [ "$TERMUX_SKIP_DEPCHECK" = true ] || [ "$TERMUX_PKG_METAPACKAGE" = true ]; then
		return 0
	fi

	if [ "$TERMUX_INSTALL_DEPS" = true ]; then
		# Download repo files
		termux_get_repo_files

		# When doing build on device, ensure that apt lists are up-to-date.
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			case "$TERMUX_APP_PACKAGE_MANAGER" in
				"apt") apt update;;
				"pacman") pacman -Sy;;
			esac
		fi
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$PKG" = "ndk-sysroot" ]; then continue; fi
			read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")
			[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Downloading dependency $PKG@$DEP_VERSION if necessary..."
			local force_build_dependency="$TERMUX_FORCE_BUILD_DEPENDENCIES"
			if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && ! pacakge__is_package_on_device_build_supported "$PKG_DIR"; then
				echo "Building dependency $PKG on device is not supported. It will be downloaded..."
				force_build_dependency="false"
			fi
			local build_dependency=false
			if [ "$force_build_dependency" = "true" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Force building dependency $PKG instead of downloading due to -I flag..."
				termux_force_check_package_dependency && continue
				build_dependency=true
			else
				if pacakge__is_package_version_built "$PKG" "$DEP_VERSION"; then
					[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Skipping already built dependency $PKG@$DEP_VERSION"
					continue
				fi
				if ! termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC; then
					if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
						echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed"
						return 1
					else
						echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed, building instead"
						build_dependency=true
					fi
				fi
			fi
			if $build_dependency; then
				TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh -I $(test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true" && echo "-F" || true) --format $TERMUX_PACKAGE_FORMAT "${PKG_DIR}"
				continue
			fi
			termux_add_package_to_built_packages_list "$PKG"
			if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "extracting $PKG to $TERMUX_COMMON_CACHEDIR-$DEP_ARCH..."
				(
					cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
					ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
					if tar -tf data.tar.xz|grep "^./$">/dev/null; then
						# Strip prefixed ./, to avoid possible
						# permission errors from tar
						tar -xf data.tar.xz --strip-components=1 \
							--no-overwrite-dir -C /
					else
						tar -xf data.tar.xz --no-overwrite-dir -C /
					fi
				)
			fi
			mkdir -p $TERMUX_BUILT_PACKAGES_DIRECTORY
			echo "$DEP_VERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG"
		done<<<$(./scripts/buildorder.py -i "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	else
		# Build dependencies
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Force building dependency $PKG..."
				if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && ! pacakge__is_package_on_device_build_supported "$PKG_DIR"; then
					echo "Building $PKG on device is not supported. Consider passing -I flag to download it instead"
					return 1
				fi
				read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")
				termux_force_check_package_dependency && continue
			else
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Building dependency $PKG if necessary..."
			fi
			TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh -s $(test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true" && echo "-F" || true) --format $TERMUX_PACKAGE_FORMAT "${PKG_DIR}"
		done<<<$(./scripts/buildorder.py "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	fi
}

termux_force_check_package_dependency() {
	if termux_check_package_in_built_packages_list "$PKG" && pacakge__is_package_version_built "$PKG" "$DEP_VERSION"; then
		[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Skipping already built dependency $PKG@$DEP_VERSION"
		return 0
	fi
	return 1
}
