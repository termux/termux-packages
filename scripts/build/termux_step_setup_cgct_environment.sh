# Installing packages if necessary for the full operation of CGCT (main use: not in Termux devices)

termux_step_setup_cgct_environment() {

	local return_value

	[ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && return

	if ! termux_repository__are_packages_in_packages_repos_usable_for_building \
			TERMUX_REPO_PACKAGES_UNUSABLE_REASON "false"; then
		logger__log 1 "WARNING: Ignoring download of glibc core packages from \
the packages repos for operation of CGCT since \
${TERMUX_REPO_PACKAGES_UNUSABLE_REASON:-"due to unknown error."}"
		logger__log 1 "The following glibc core packages for the current \
package build variables in the 'properties.sh' file like \
TERMUX_APP__PACKAGE_NAME '$TERMUX_APP__PACKAGE_NAME' and \
TERMUX__PREFIX '$TERMUX__PREFIX' must be manually installed: \
'gcc-libs-glibc', 'glibc' and 'linux-api-headers-glibc'"
		return 0
	fi

	local i
	local DEP_PKG_DIR
	local DEP_PKG_NAME
	local TERMUX_REPO_URL

	for DEP_PKG_NAME in gcc-libs-glibc glibc linux-api-headers-glibc; do
		DEP_PKG_DIR=""
		for i in "${!TERMUX_REPO__CHANNEL_DIRS[@]}"; do
			repo_channel_dir="${TERMUX_REPO__CHANNEL_DIRS["$i"]}"
			if [[ -f "${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${DEP_PKG_NAME}/build.sh" ]]; then
				DEP_PKG_DIR="${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${DEP_PKG_NAME}"
			elif [[ -f "${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${DEP_PKG_NAME/-glibc/}/build.sh" ]]; then
				DEP_PKG_DIR="${TERMUX_SCRIPTDIR}/${repo_channel_dir}/${DEP_PKG_NAME/-glibc/}"
			else
				continue
			fi

			TERMUX_REPO_URL="${TERMUX_REPO__CHANNEL_URLS["$i"]}"
			if [ -z "$TERMUX_REPO_URL" ]; then
				termux_error_exit "The url not set for '${TERMUX_REPO__CHANNEL_NAMES["$i"]}' repo for cgct dependency '$DEP_PKG_NAME'"
			fi

			break
		done
		if [ -z "$DEP_PKG_DIR" ]; then
			termux_error_exit "Failed to find package directory for cgct dependency '$DEP_PKG_NAME'"
		fi

		# FIXME:
		read DEP_ARCH DEP_VERSION DEP_VERSION_PAC <<< $(termux_extract_dep_info "$DEP_PKG_NAME" "$DEP_PKG_DIR")

		if ! termux_package__is_package_version_built "$DEP_PKG_NAME" "$DEP_VERSION" && \
				[ ! -f "$TERMUX_BUILT_PACKAGES_DIRECTORY/${DEP_PKG_NAME}-for-cgct" ]; then
			[ ! "$TERMUX_QUIET_BUILD" = "true" ] && echo "Installing '$DEP_PKG_NAME' for the CGCT tool environment."

			return_value=0
			TERMUX_WITHOUT_DEPVERSION_BINDING=true TERMUX_ON_DEVICE_BUILD=false \
				termux_download_deb_pac "$DEP_PKG_NAME" "$DEP_PKG_DIR" "$DEP_ARCH" "$DEP_VERSION" "$DEP_VERSION_PAC" || return_value=$?
			if [ $return_value -ne 0 ]; then
				logger__log_errors "Failed to download cgct dependency '$DEP_PKG_NAME' from packages repo."
				return $return_value
			fi

			mkdir -p "$TERMUX_BUILT_PACKAGES_DIRECTORY"
			echo "" > "$TERMUX_BUILT_PACKAGES_DIRECTORY/${DEP_PKG_NAME}-for-cgct"
		fi
	done

}
