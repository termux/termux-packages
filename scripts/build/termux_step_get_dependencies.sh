termux_step_get_dependencies() {
	if [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = true ] && [ "$TERMUX_PKG_METAPACKAGE" = "false" ]; then
		# Download repo files
		termux_get_repo_files

		# When doing build on device, ensure that apt lists are up-to-date.
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			case "$TERMUX_APP_PACKAGE_MANAGER" in
				"apt") apt update;;
				"pacman") pacman -Sy;;
			esac
		fi

		# Download dependencies
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$PKG" = "ndk-sysroot" ]; then continue; fi
			read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")

			if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
				echo "Downloading dependency $PKG@$DEP_VERSION if necessary..."
			fi

			if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG" ]; then
				if [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG")" = "$DEP_VERSION" ]; then
					if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
						echo "Skipping already built dependency $PKG@$DEP_VERSION"
					fi
					continue
				fi
			fi

			if ! termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC; then
				echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed, building instead"
				TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh $((test "${TERMUX_FORCE_BUILD}" = "true" && test "${TERMUX_FORCE_BUILD_SPECIFIED}" = "false") && echo "-f" || true) -I --format $TERMUX_PACKAGE_FORMAT "${PKG_DIR}"
				continue
			fi
			if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
				if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
					echo "extracting $PKG to $TERMUX_COMMON_CACHEDIR-$DEP_ARCH..."
				fi
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
	elif [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = false ] && [ "$TERMUX_PKG_METAPACKAGE" = "false" ]; then
		# Build dependencies
		while read PKG PKG_DIR; do
			local CHANGE_TERMUX_FORCE_BUILD=false

			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi

			local TERMUX_PKG_COMPILE_ACCESS_FOR_DEVICE=$(cat ${PKG_DIR}/build.sh | grep TERMUX_PKG_COMPILE_ACCESS_FOR_DEVICE | awk -F= '{printf $2}')
			if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && [ "$TERMUX_PKG_COMPILE_ACCESS_FOR_DEVICE" = "false" ]; then
				echo "Attention: the package '$PKG' does not support compilation on the device, so it will be installed."
				read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR}")
				if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG" ]; then
					if [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG")" = "$DEP_VERSION" ]; then
						if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
							echo "Skipping already built dependency $PKG@$DEP_VERSION"
						fi
						continue
					fi
				fi
				case "$TERMUX_APP_PACKAGE_MANAGER" in
					"apt") apt update
					       apt install -y "${PKG}=${DEP_VERSION}";;
					"pacman") pacman -Sy
						  pacman -S "${PKG}=${DEP_VERSION_PAC}" --needed --noconfirm;;
				esac
				mkdir -p $TERMUX_BUILT_PACKAGES_DIRECTORY
				echo "$DEP_VERSION" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG"
				if [ "$TERMUX_FORCE_BUILD" = "true" ]; then
					TERMUX_FORCE_BUILD=false
					CHANGE_TERMUX_FORCE_BUILD=true
				fi
			fi

			echo "Building dependency $PKG if necessary..."
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh $((test "${TERMUX_FORCE_BUILD}" = "true" && test "${TERMUX_FORCE_BUILD_SPECIFIED}" = "false") && echo "-f" || true) -s --format $TERMUX_PACKAGE_FORMAT "${PKG_DIR}"

			if $CHANGE_TERMUX_FORCE_BUILD; then
				TERMUX_FORCE_BUILD=true
			fi
		done<<<$(./scripts/buildorder.py "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	fi
}
