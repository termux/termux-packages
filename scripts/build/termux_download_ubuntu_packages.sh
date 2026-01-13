#!/usr/bin/bash

termux_download_ubuntu_packages() {
	{
		(( $# )) || {
			echo "termux_download_ubuntu_packages():"
			echo "Usage: termux_download_ubuntu_packages [PACKAGES...]"
			echo "You can additionally overwrite the following parameters via environment variables"
			echo "\$VAR [default value]"
			echo ""
			echo "DESTINATION    [\$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages]"
			echo "ARCHITECTURE   [amd64]"
			echo "MIRROR_URL     [https://archive.ubuntu.com/ubuntu]"
			echo "UBUNTU_RELEASE [noble] # latest Ubuntu LTS"
			return 1
		}

		if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
			echo "termux_download_ubuntu_packages(): This function should not be used during on-device building!"
			return 1
		fi
	} 1>&2

	local DESTINATION ARCHITECTURE MIRROR_URL UBUNTU_RELEASE

	: "${DESTINATION:="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages"}"
	: "${ARCHITECTURE:=amd64}"
	: "${MIRROR_URL:="https://archive.ubuntu.com/ubuntu"}"
	: "${UBUNTU_RELEASE:=noble}" # Default to latest Ubuntu LTS, currently 24.04 Noble Numbat

	mkdir -p "$DESTINATION"

	local cache_directory="${TERMUX_PKG_TMPDIR}/Packages_ubuntu_${UBUNTU_RELEASE}_${ARCHITECTURE}"

	# Fetch and cache the package lists for the repo channels
	local channel
	for channel in "main" "restricted" "universe" "multiverse"; do
		# Do we already have this?
		if [[ ! -e "${cache_directory}_$channel.gz" ]]; then
			echo "Downloading package index for Ubuntu '$UBUNTU_RELEASE:${ARCHITECTURE}' ${channel}"
			curl -sL \
				-o "${cache_directory}_$channel.gz" \
				"${MIRROR_URL}/dists/${UBUNTU_RELEASE}/${channel}/binary-${ARCHITECTURE}/Packages.gz"
		else
			echo "Already have package index for Ubuntu '$UBUNTU_RELEASE:${ARCHITECTURE}' ${channel}"
		fi
	done


	local package package_filename package_sha256
	for package in "$@"; do

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
