termux_step_get_dependencies() {
	if [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = true ] && [ "$TERMUX_PKG_METAPACKAGE" = "false" ]; then
		# Download repo files
		termux_get_repo_files

		# When doing build on device, ensure that apt lists are up-to-date.
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			case "$TERMUX_MAIN_PACKAGE_FORMAT" in
			"debian") apt update ;;
			"pacman") pacman -Sy ;;
			esac
		fi

		# We use this variable to track what haskell packages are required by this build,
		# which needs to be registered in the cross ghc package database.
		declare -a HASKELL_PKGS_TO_REGISTER=()
		# We do not allow setting up ghc cross compiler manually as they need to be installed in $TERMUX_PREFIX,
		# which should be done before timestamp creation.
		local IS_GHC_REQUIRED=false # Whether we need to setup GHC cross compiler.
		# Download dependencies
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			elif [ "$PKG" = "ghc" ] || [ "$PKG" = "ghc-libs" ] || [ "$PKG" = "ghc-libs-static" ]; then
				IS_GHC_REQUIRED=true
			fi
			# Store haskell packages to register them in the cross ghc package database later.
			if [ "${PKG/haskell-/}" != "$PKG" ]; then
				HASKELL_PKGS_TO_REGISTER+=("${PKG}")
			fi
			# llvm doesn't build if ndk-sysroot is installed:
			if [ "$PKG" = "ndk-sysroot" ]; then continue; fi

			read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<<$(termux_extract_dep_info $PKG "${PKG_DIR}")

			if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
				echo "Downloading dependency $PKG@$DEP_VERSION if necessary..."
			fi

			if [ -e "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG" ]; then
				if [ "$(cat "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG")" = "$DEP_VERSION" ]; then
					continue
				fi
			fi

			if ! termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC; then
				echo "Download of $PKG@$DEP_VERSION from $TERMUX_REPO_URL failed, building instead"
				TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh -I --format $TERMUX_PACKAGE_FORMAT "${PKG_DIR}"
				continue
			fi
			if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
				if [ ! "$TERMUX_QUIET_BUILD" = true ]; then
					echo "extracting $PKG..."
				fi
				(
					cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
					ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
					if tar -tf data.tar.xz | grep "^./$" >/dev/null; then
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
			echo "$DEP_VERSION" >"$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG"
		done <<<$(./scripts/buildorder.py -i "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	elif [ "$TERMUX_SKIP_DEPCHECK" = false ] && [ "$TERMUX_INSTALL_DEPS" = false ] && [ "$TERMUX_PKG_METAPACKAGE" = "false" ]; then
		# Build dependencies
		while read PKG PKG_DIR; do
			if [ -z $PKG ]; then
				continue
			elif [ "$PKG" = "ERROR" ]; then
				termux_error_exit "Obtaining buildorder failed"
			fi
			echo "Building dependency $PKG if necessary..."
			# Built dependencies are put in the default TERMUX_OUTPUT_DIR instead of the specified one
			TERMUX_BUILD_IGNORE_LOCK=true ./build-package.sh -s --format $TERMUX_PACKAGE_FORMAT "${PKG_DIR}"
		done <<<$(./scripts/buildorder.py "$TERMUX_PKG_BUILDER_DIR" $TERMUX_PACKAGES_DIRECTORIES || echo "ERROR")
	fi

	if [ "${IS_GHC_REQUIRED}" = true ]; then
		termux_setup_ghc_cross_compiler
	fi
	# Register haskell packages either installed or built, which are required by this build, with cross ghc.
	for pkg in "${HASKELL_PKGS_TO_REGISTER[@]}"; do
		echo "${pkg} is an haskell package, registering it with ghc-pkg..."
		sed "s|${TERMUX_PREFIX}/bin/ghc-pkg|$(command -v termux-ghc-pkg)|g" \
			"${TERMUX_PREFIX}/share/haskell/register/${pkg}.sh" | sh
		termux-ghc-pkg recache
	done
}
