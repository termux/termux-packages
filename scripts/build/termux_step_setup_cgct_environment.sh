# Installing packages if necessary for the full operation of CGCT (main use: not in Termux devices)

termux_step_setup_cgct_environment() {
	[ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && return

	if [ "$TERMUX_REPO_PACKAGE" != "$TERMUX_APP_PACKAGE" ]; then
		echo "WARNING: It is not possible to install glibc core packages from the repo for operation of CGCT, you must install glibc packages for your application with the prefix '$TERMUX_PREFIX' yourself (core packages: glibc and linux-api-headers-glibc)."
		return
	fi

	for PKG in gcc-libs-glibc glibc linux-api-headers-glibc; do
		local PKG_DIR=$(ls ${TERMUX_SCRIPTDIR}/*/${PKG}/build.sh 2> /dev/null || \
			ls ${TERMUX_SCRIPTDIR}/*/${PKG/-glibc/}/build.sh 2> /dev/null)
		if [ -z "$PKG_DIR" ]; then
			termux_error_exit "Could not find build.sh file for package '${PKG}'"
		fi
		local PKG_DIR_SPLIT=(${PKG_DIR//// })

		local REPO_NAME=""
		local LIST_PACKAGES_DIRECTORIES=(${TERMUX_PACKAGES_DIRECTORIES})
		for idx in ${!LIST_PACKAGES_DIRECTORIES[@]}; do
			if [ "${LIST_PACKAGES_DIRECTORIES[$idx]}" = "${PKG_DIR_SPLIT[-3]}" ]; then
				REPO_NAME=$(echo "${TERMUX_REPO_URL[$idx]}" | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
				if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
					REPO_NAME+="-${TERMUX_REPO_DISTRIBUTION[$idx]}-Release"
				elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
					REPO_NAME+="-json"
				fi
				break
			fi
		done
		if [ -z "$REPO_NAME" ]; then
			termux_error_exit "Could not find '${PKG_DIR_SPLIT[-3]}' repo"
		fi

		read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info $PKG "${PKG_DIR/'/build.sh'/}")

		if ! termux_package__is_package_version_built "$PKG" "$DEP_VERSION" && [ ! -f "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG-for-cgct" ]; then
			[ ! "$TERMUX_QUIET_BUILD" = "true" ] && echo "Installing '${PKG}' for the CGCT tool environment."

			if [ ! -f "${TERMUX_COMMON_CACHEDIR}-${DEP_ARCH}/${REPO_NAME}" ]; then
				TERMUX_INSTALL_DEPS=true termux_get_repo_files
			fi

			if ! TERMUX_WITHOUT_DEPVERSION_BINDING=true termux_download_deb_pac $PKG $DEP_ARCH $DEP_VERSION $DEP_VERSION_PAC; then
				termux_error_exit "Failed to download package '${PKG}'"
			fi

			[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "extracting $PKG to $TERMUX_COMMON_CACHEDIR-$DEP_ARCH..."
			(
				cd $TERMUX_COMMON_CACHEDIR-$DEP_ARCH
				if [ "$TERMUX_REPO_PKG_FORMAT" = "debian" ]; then
					ar x ${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb data.tar.xz
					if tar -tf data.tar.xz|grep "^./$">/dev/null; then
						tar -xf data.tar.xz --strip-components=1 \
							--no-overwrite-dir -C /
					else
						tar -xf data.tar.xz --no-overwrite-dir -C /
					fi
				elif [ "$TERMUX_REPO_PKG_FORMAT" = "pacman" ]; then
					tar -xJf "${PKG}-${DEP_VERSION_PAC}-${DEP_ARCH}.pkg.tar.xz" \
						--exclude=".BUILDINFO" --exclude=".PKGINFO" \
						--exclude=".MTREE" --exclude=".INSTALL" \
						--force-local --no-overwrite-dir -C /
				fi
			)
			mkdir -p $TERMUX_BUILT_PACKAGES_DIRECTORY
			echo "" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG-for-cgct"
		fi
	done
}
