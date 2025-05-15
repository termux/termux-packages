termux_get_repo_files() {

	local return_value

	# If already downloaded, then just return.
	if [[ "${TERMUX_REPO__REPO_METADATA_FILES_DOWNLOADED:-}" == "true" ]]; then
		return 0
	fi

	# If building on device.
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		# Ensure that package manager packages metadata caches are up-to-date.
		case "$TERMUX_APP_PACKAGE_MANAGER" in
			"apt") apt update || return_value=74;; # EX__IOERR (download failure)
			"pacman") pacman -Sy || return_value=74;; # EX__IOERR (download failure)
		esac
	else
		unset TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS
		declare -A TERMUX_REPO__CHANNEL_SIGNING_KEY_NAMES_AND_FINGERPRINTS=()
		# Import signing keys for each repo channel in repo.json file
		# for verifying signature of repo metadata files to be downloaded.
		termux_repository__import_repo_signing_keys_to_keystore "$TERMUX_SCRIPTDIR" \
			"$TERMUX_SCRIPTDIR/repo.json" || return $?

		# Download repo metadata files.
		return_value=0
		termux_repository__download_repo_metadata_files "$TERMUX_SCRIPTDIR" "$TERMUX_COMMON_CACHEDIR" \
			"$TERMUX_ARCH" || return_value=$?
	fi

	if [ $return_value -ne 0 ]; then
		logger__log_errors "Failed to downloading repo metadata files"
		if [ $return_value -eq 74 ]; then # EX__IOERR (download failure)
			logger__log_errors "Try to build without -i/-I option."
			# Failing to download repo metadata files should be
			# considered a critical errors by callers and so override
			# the exit code. However, failing to download a specific
			# package is not considered a critical error as package
			# could be built locally if possible as package or its
			# required version may not have been uploaded to repo.
			return_value=1
		fi
		return $return_value
	fi

	TERMUX_REPO__REPO_METADATA_FILES_DOWNLOADED="true"

}
