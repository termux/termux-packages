# shellcheck shell=bash disable=SC2115
termux_setup_mold() {
	# Experimental and disabled for now
	# build issue with arm CMake based projects
	# https://github.com/rui314/mold/issues/864
	# build issue with LTO
	# https://github.com/android/ndk/issues/1806

	export LDFLAGS+=" -fuse-ld=mold"

	[[ -n "$(command -v mold)" ]] && return

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		echo "ERROR: Package 'mold' is not installed." >&2
		local TERMUX_PKG_COMMAND
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' mold 2>/dev/null)" != "installed" ]]; then
			TERMUX_PKG_COMMAND="pkg install"
		fi
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q mold 2>/dev/null)" ]]; then
			TERMUX_PKG_COMMAND="pacman -S"
		fi
		if [[ -n "${TERMUX_PKG_COMMAND}" ]]; then
			echo "You can install it with '${TERMUX_PKG_COMMAND} mold'" >&2
		fi
		exit 1
	fi

	local TERMUX_MOLD_VERSION=1.7.1
	local TERMUX_MOLD_TARFILE_SHA256=66b38b8ab3143f23c1eaad598dd9055ce84f39729f92d63eddbd856a73d65784
	local TERMUX_MOLD_TARNAME="mold-${TERMUX_MOLD_VERSION}-x86_64-linux"
	local TERMUX_MOLD_TARFILE="${TERMUX_MOLD_TARNAME}.tar.gz"

	local TERMUX_MOLD_FOLDER
	if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
		TERMUX_MOLD_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/mold-${TERMUX_MOLD_VERSION}"
	else
		TERMUX_MOLD_FOLDER="${TERMUX_COMMON_CACHEDIR}/mold-${TERMUX_MOLD_VERSION}"
	fi

	if [[ ! -d "${TERMUX_MOLD_FOLDER}" ]]; then
		termux_download \
			"https://github.com/rui314/mold/releases/download/v${TERMUX_MOLD_VERSION}/${TERMUX_MOLD_TARFILE}" \
			"${TERMUX_PKG_TMPDIR}/${TERMUX_MOLD_TARFILE}" \
			"${TERMUX_MOLD_TARFILE_SHA256}"
		rm -fr "${TERMUX_PKG_TMPDIR}/${TERMUX_MOLD_TARNAME}"
		tar -xf "${TERMUX_PKG_TMPDIR}/${TERMUX_MOLD_TARFILE}" -C "${TERMUX_PKG_TMPDIR}"
		mv "${TERMUX_PKG_TMPDIR}/${TERMUX_MOLD_TARNAME}" "${TERMUX_MOLD_FOLDER}"
	fi

	export PATH="${TERMUX_MOLD_FOLDER}/bin:${PATH}"

	if [[ -z "$(command -v mold)" ]]; then
		echo "ERROR: termux_setup_mold failed!" >&2
		exit 1
	fi
}
