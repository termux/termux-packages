termux_step_get_dependencies() {
	if [ "$TERMUX_SKIP_DEPCHECK" = true ] || [ "$TERMUX_PKG_METAPACKAGE" = true ]; then
		return 0
	fi

	if [ "$TERMUX_INSTALL_DEPS" = true ]; then
		# Download repo files
		termux_download_repo_file
	fi

	while read PKG PKG_DIR; do
		# Checking for duplicate dependencies
		local cyclic_dependence=false
		if termux_check_package_in_building_packages_list "$PKG_DIR"; then
			echo "A circular dependency was found on '$PKG', the old version of the package will be installed to resolve the conflict"
			cyclic_dependence=true
			if [ "$TERMUX_INSTALL_DEPS" = false ]; then
				TERMUX_INSTALL_DEPS=true termux_download_repo_file
			fi
		fi

		if [ "$TERMUX_INSTALL_DEPS" = true ] || [ "$cyclic_dependence" = true ]; then
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$PKG" = "ndk-sysroot" ]; then continue; fi
			read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")
			if [ "$cyclic_dependence" = false ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Downloading dependency $PKG$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} = false && echo "@$DEP_VERSION") if necessary..."
				local force_build_dependency="$TERMUX_FORCE_BUILD_DEPENDENCIES"
				if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && ! termux_package__is_package_on_device_build_supported "$PKG_DIR"; then
					echo "Building dependency $PKG on device is not supported. It will be downloaded..."
					force_build_dependency="false"
				fi
			else
				local force_build_dependency=false
			fi
			local build_dependency=false
			if [ "$force_build_dependency" = "true" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Force building dependency $PKG instead of downloading due to -I flag..."
				termux_force_check_package_dependency && continue
				build_dependency=true
			else
				if termux_package__is_package_version_built "$PKG" "$DEP_VERSION"; then
					[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Skipping already built dependency $PKG$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} = false && echo "@$DEP_VERSION")"
					continue
				fi
				if ! TERMUX_WITHOUT_DEPVERSION_BINDING=$(test "${cyclic_dependence}" = "true" && echo "true" || echo "${TERMUX_WITHOUT_DEPVERSION_BINDING}") termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC; then
					if [ "$cyclic_dependence" = "true" ] || ([ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ] && [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]); then
						echo "Download of $PKG$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} = false && test ${cyclic_dependence} = false && echo "@$DEP_VERSION") from $TERMUX_REPO_URL failed"
						return 1
					else
						echo "Download of $PKG$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} = false && echo "@$DEP_VERSION") from $TERMUX_REPO_URL failed, building instead"
						build_dependency=true
					fi
				fi
			fi
			if [ "$cyclic_dependence" = false ]; then
				if $build_dependency; then
					termux_run_build-package
					continue
				fi
				termux_add_package_to_built_packages_list "$PKG"
			fi
			if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "extracting $PKG to $TERMUX_COMMON_CACHEDIR-$DEP_ARCH..."
				(
					cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
					if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
						ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
						if tar -tf data.tar.xz|grep "^./$">/dev/null; then
							# Strip prefixed ./, to avoid possible
							# permission errors from tar
							tar -xf data.tar.xz --strip-components=1 \
								--no-overwrite-dir -C /
						else
							tar -xf data.tar.xz --no-overwrite-dir -C /
						fi
					elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
						tar -xJf "${PKG}-${DEP_VERSION_PAC}-${DEP_ARCH}.pkg.tar.xz" \
							--anchored --exclude=.{BUILDINFO,PKGINFO,MTREE,INSTALL} \
							--force-local --no-overwrite-dir -C /
					fi
				)
			fi
			mkdir -p $TERMUX_BUILT_PACKAGES_DIRECTORY
			if [ "$cyclic_dependence" = "false" ] && ([ "$TERMUX_WITHOUT_DEPVERSION_BINDING" = "false" ] || [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]); then
				echo "$DEP_VERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG"
			fi
		else
		# Build dependencies
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			if [ "$TERMUX_FORCE_BUILD_DEPENDENCIES" = "true" ]; then
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Force building dependency $PKG..."
				if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && ! termux_package__is_package_on_device_build_supported "$PKG_DIR"; then
					echo "Building $PKG on device is not supported. Consider passing -I flag to download it instead"
					return 1
				fi
				read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")
				termux_force_check_package_dependency && continue
			else
				[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Building dependency $PKG if necessary..."
			fi
			termux_run_build-package
		fi
	done<<<$(./scripts/buildorder.py $(test "${TERMUX_INSTALL_DEPS}" = "true" && echo "-i") "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
}

termux_force_check_package_dependency() {
	if termux_check_package_in_built_packages_list "$PKG" && termux_package__is_package_version_built "$PKG" "$DEP_VERSION"; then
		[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "Skipping already built dependency $PKG$(test ${TERMUX_WITHOUT_DEPVERSION_BINDING} = false && echo "@$DEP_VERSION")"
		return 0
	fi
	return 1
}

termux_run_build-package() {
	local set_library
	if [ "$TERMUX_GLOBAL_LIBRARY" = "true" ]; then
		set_library="$TERMUX_PACKAGE_LIBRARY -L"
	else
		set_library="bionic"
		if termux_package__is_package_name_have_glibc_prefix "$PKG"; then
			set_library="glibc"
		fi
	fi
	TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh \
		$(test "${TERMUX_INSTALL_DEPS}" = "true" && echo "-I") \
 		$(test "${TERMUX_FORCE_BUILD_DEPENDENCIES}" = "true" && echo "-F") \
   		$(test "${TERMUX_WITHOUT_DEPVERSION_BINDING}" = "true" && echo "-w") \
     		--format $TERMUX_PACKAGE_FORMAT --library $set_library "${PKG_DIR}"
}

termux_download_repo_file() {
	termux_get_repo_files

	# When doing build on device, ensure that apt lists are up-to-date.
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			"apt") apt update;;
			"pacman") pacman -Sy;;
		esac
	fi
}
