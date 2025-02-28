# shellcheck shell=bash
# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc_cross_compiler() {
	local TERMUX_GHC_VERSION=9.10.1
	local GHC_PREFIX="ghc-cross-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}"
	local TERMUX_GHC_TEMP_FOLDER="$TERMUX_COMMON_CACHEDIR/$GHC_PREFIX"
	local TERMUX_GHC_TAR="$TERMUX_GHC_TEMP_FOLDER.tar.xz"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == false ]]; then
		local TERMUX_GHC_RUNTIME_FOLDER

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == true ]]; then
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/${GHC_PREFIX}-runtime"
		else
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
		fi

		export PATH="${TERMUX_GHC_RUNTIME_FOLDER}/bin:${PATH}"

		test -d "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}" ||
			termux_error_exit "Package 'ghc-libs' is not installed. It is required by GHC cross-compiler." \
				"You should specify it in 'TERMUX_PKG_BUILD_DEPENDS'."

		[[ -d "${TERMUX_GHC_RUNTIME_FOLDER}" ]] && return

		local CHECKSUMS
		CHECKSUMS="$(
			cat <<-EOF
				aarch64:66d97d2c027c831f63f046a000c78eafde966f163d2d8c2ce5a7de86d0c72a85
				arm:dca3aa7a523054e5b472793afb0d750162052ffa762122c1200e5d832187bb86
				i686:428c26a4c2a26737a9c031dbe7545c6514d9042cb28d926ffa8702c2930326c5
				x86_64:1b27fa3dfa02cc9959b43a82b2881b55a1def397da7e7f7ff64406c666763f50
			EOF
		)"

		local host_platform="$TERMUX_HOST_PLATFORM"
		if [ "$TERMUX_ARCH" = "arm" ]; then
			host_platform="armv7a-linux-androideabi"
		fi

		termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v${TERMUX_GHC_VERSION}/ghc-${TERMUX_GHC_VERSION}-${host_platform}.tar.xz" \
			"${TERMUX_GHC_TAR}" \
			"$(echo "${CHECKSUMS}" | grep -w "${TERMUX_ARCH}" | cut -d ':' -f 2)"

		mkdir -p "${TERMUX_GHC_RUNTIME_FOLDER}"
		tar -xf "${TERMUX_GHC_TAR}" -C "${TERMUX_GHC_TEMP_FOLDER}" --strip-components=1

		(
			set -e
			cd "$TERMUX_GHC_TEMP_FOLDER"
			./configure --prefix="$TERMUX_GHC_RUNTIME_FOLDER" --host="$host_platform"
			make install
		) # XXX: Add it in production: &>/dev/null

		rm -rf "${TERMUX_GHC_TAR}" "$TERMUX_GHC_TEMP_FOLDER"

	else
		if [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ||
			[[ "${TERMUX_APP_PACKAGE_MANAGER}" == "pacman" ]] && ! "$(pacman -Q ghc 2>/dev/null)"; then
			echo "Package 'ghc' is not installed."
			exit 1
		fi
	fi
}
