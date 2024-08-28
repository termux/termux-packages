# Installing packages if necessary for the full operation of CGCT (main use: not in Termux devices)

termux_step_setup_cgct_environment() {
	[ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && return

	if [ "$TERMUX_REPO_PACKAGE" != "$TERMUX_APP_PACKAGE" ]; then
		echo "WARNING: It is not possible to install glibc core packages from the repo for operation of CGCT, you must install glibc packages for your application with the prefix '$TERMUX_PREFIX' yourself (core packages: glibc and linux-api-headers-glibc)."
		return
	fi

	local i
	local PKG_DIR
	local TERMUX_REPO_URL
	local TERMUX_REPO_URL_ID=""
	for PKG in gcc-libs-glibc glibc linux-api-headers-glibc; do
		PKG_DIR=""
		TERMUX_REPO_URL_ID=""
		for i in "${!TERMUX_REPO__CHANNEL_DIRS[@]}"; do
			repo_channel_dir="${TERMUX_REPO__CHANNEL_DIRS["$i"]}"
			if [[ -f "${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${PKG}/build.sh" ]]; then
				PKG_DIR="${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${PKG}"
			elif [[ -f "${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${PKG/-glibc/}/build.sh" ]]; then
				PKG_DIR="${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${PKG/-glibc/}"
			else
				continue
			fi

			TERMUX_REPO_URL="${TERMUX_REPO__CHANNEL_URLS["$i"]}"
			if [ -z "$TERMUX_REPO_URL" ]; then
				termux_error_exit "The url not set for '${TERMUX_REPO__CHANNEL_NAMES["$i"]}' repo for package '$PKG'"
			fi

			TERMUX_REPO_URL_ID=$(echo "$TERMUX_REPO_URL" | sed -e 's%https://%%g' -e 's%http://%%g' -e 's%/%-%g')
			if [ "$TERMUX_REPO__PKG_FORMAT" = "debian" ]; then
				TERMUX_REPO_URL_ID+="-${TERMUX_REPO__CHANNEL_DISTRIBUTIONS["$i"]}-Release"
			elif [ "$TERMUX_REPO__PKG_FORMAT" = "pacman" ]; then
				TERMUX_REPO_URL_ID+="-json"
			fi
			break

		done
		if [ -z "$PKG_DIR" ]; then
			termux_error_exit "Failed to find package directory for package '$PKG'"
		fi

		read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info "$PKG" "$PKG_DIR")

		if ! package__is_package_version_built "$PKG" "$DEP_VERSION" && [ ! -f "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG-for-cgct" ]; then
			[ ! "$TERMUX_QUIET_BUILD" = "true" ] && echo "Installing '${PKG}' for the CGCT tool environment."

			if [ ! -f "${TERMUX_COMMON_CACHEDIR}-${DEP_ARCH}/${TERMUX_REPO_URL_ID}" ]; then
				TERMUX_INSTALL_DEPS=true termux_get_repo_files
			fi

			if ! TERMUX_WITHOUT_DEPVERSION_BINDING=true termux_download_deb_pac "$PKG" "$DEP_ARCH" "$DEP_VERSION" "$DEP_VERSION_PAC"; then
				termux_error_exit "Failed to download package '${PKG}'"
			fi

			[ ! "$TERMUX_QUIET_BUILD" = true ] && echo "extracting $PKG to $TERMUX_COMMON_CACHEDIR-$DEP_ARCH..."
			(
				cd "$TERMUX_COMMON_CACHEDIR-$DEP_ARCH"
				if [ "$TERMUX_REPO__PKG_FORMAT" = "debian" ]; then
					ar x "${PKG}_${DEP_VERSION}_${DEP_ARCH}.deb" data.tar.xz
					if tar -tf data.tar.xz|grep "^./$">/dev/null; then
						tar -xf data.tar.xz --strip-components=1 \
							--no-overwrite-dir -C /
					else
						tar -xf data.tar.xz --no-overwrite-dir -C /
					fi
				elif [ "$TERMUX_REPO__PKG_FORMAT" = "pacman" ]; then
					tar -xJf "${PKG}-${DEP_VERSION_PAC}-${DEP_ARCH}.pkg.tar.xz" \
						--force-local --no-overwrite-dir -C / data
				fi
			)
			mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
			echo "" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/$PKG-for-cgct"
		fi
	done
}
