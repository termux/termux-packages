#!/usr/bin/bash

termux_download_ubuntu_packages() {
	{
		if (( $# < 1 || $# > 4 )); then
			echo "termux_download_ubuntu_packages(): Invalid arguments - expected <PACKAGES> [<DESTINATION>] [<ARCHITECTURE>] [<MIRROR_URL>]"
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
	local MIRROR_URL="${4:-"https://archive.ubuntu.com/ubuntu"}"

	mkdir -p "$DESTINATION"

	local cache_directory="${TERMUX_PKG_TMPDIR}/Packages_ubuntu_${ubuntu_release}_${ARCHITECTURE}"

	# Fetch and cache the package lists for the repo channels
	local channel
	for channel in "main" "restricted" "universe" "multiverse"; do
		# Do we already have this?
		if [[ ! -e "${cache_directory}_$channel.gz" ]]; then
			echo "Downloading package index for Ubuntu '$ubuntu_release:${ARCHITECTURE}' ${channel}"
			curl -sL \
				-o "${cache_directory}_$channel.gz" \
				"${MIRROR_URL}/dists/${ubuntu_release}/${channel}/binary-${ARCHITECTURE}/Packages.gz"
		else
			echo "Already have package index for Ubuntu '$ubuntu_release:${ARCHITECTURE}' ${channel}"
		fi
	done


	local package package_filename package_sha256
	for package in $PACKAGES; do

		read -rd$'\n' package_filename package_sha256 < <(
			zcat  "$cache_directory"*.gz | \
			sed -n "/^Package: ${package}\$/,/^Package:/ {
					s/^Filename: //p
					s/^SHA256: //p
			}"
		)

		printf -v deb_url '%s/%s' \
			"$MIRROR_URL" \
			"$package_filename"

		echo "termux_download_ubuntu_packages(): Downloading '$package'"
		local deb_name
		deb_name="${deb_url##*/}"
		termux_download "$deb_url" "${TERMUX_COMMON_CACHEDIR}/${deb_name}" "${package_sha256}"
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
