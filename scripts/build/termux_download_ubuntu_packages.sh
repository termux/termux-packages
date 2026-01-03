#!/usr/bin/bash

termux_download_ubuntu_packages() {
	{
		if (( $# < 1 || $# > 4 )); then
			echo "termux_download_ubuntu_packages(): Invalid arguments - expected <PACKAGES> [<DESTINATION>] [<ARCHITECTURE>] [<REPOSITORY_URL>]"
			return 1
		fi
		if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
			echo "termux_download_ubuntu_packages(): This function should not be used during on-device building!"
			return 1
		fi
	} 1>&2

	local PACKAGES="${1//,/ }"
	local DESTINATION="${2:-"$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages"}"
	local ARCHITECTURE="${3:-amd64}"
	local ubuntu_release="noble" # 24.04
	local REPOSITORY_URL="${4:-"https://packages.ubuntu.com/$ubuntu_release"}"

	mkdir -p "$DESTINATION"

	local package
	for package in $PACKAGES; do
		local summary_url

		echo "termux_download_ubuntu_packages(): Downloading summary page for '$package'"
		summary_url="$REPOSITORY_URL/$ARCHITECTURE/$package/download"

		local attempt deb_url wait=50 retries=10
		for (( attempt = 1; attempt <= retries; attempt++ )); do
			local summary_file

			summary_file="${TERMUX_COMMON_CACHEDIR}/${package}-summary-page.html"
			# sometimes, error 500 occurs when attempting to download the summary page,
			# and termux_download can successfully handle that case using its own retries
			termux_download "$summary_url" "$summary_file" SKIP_CHECKSUM
			# capturing any nonzero return value from 'grep' using 'if' instead of terminating is intentional
			if deb_url="$(grep -oE 'https?://.*\.deb' "$summary_file" | head -n1)"; then
				break
			else
				# sometimes, a summary page is downloaded, but does not contain any valid package URLs,
				# so needs to be discarded and redownloaded after a medium amount of time, but if the summary page is
				# redownloaded too soon after an invalid summary page was downloaded, it is often still invalid
				echo "termux_download_ubuntu_packages(): Attempt $attempt: Failed to obtain valid summary page for '$package'. Retrying in $wait seconds..." 1>&2
				rm -f "$summary_file"
			fi

			sleep "$wait"
		done

		if [[ -z "$deb_url" ]]; then
			echo "termux_download_ubuntu_packages(): Failed to obtain '$package' after $retries attempts." 1>&2
			return 1
		fi

		echo "termux_download_ubuntu_packages(): Downloading '$package'"
		local deb_name
		deb_name="${deb_url##*/}"
		termux_download "$deb_url" "${TERMUX_COMMON_CACHEDIR}/${deb_name}" SKIP_CHECKSUM
		mkdir -p "${TERMUX_PKG_TMPDIR}/${deb_name}"
		ar x "${TERMUX_COMMON_CACHEDIR}/${deb_name}" --output="${TERMUX_PKG_TMPDIR}/${deb_name}"
		tar xf "${TERMUX_PKG_TMPDIR}/${deb_name}"/data.tar.* -C "${DESTINATION}"
	done

	return 0
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download_ubuntu_packages "$@"
fi
