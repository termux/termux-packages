# shellcheck shell=bash
# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc_cross_compiler() {
	local TERMUX_GHC_VERSION=9.12.1
	local GHC_PREFIX="ghc-cross-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}"
	local TERMUX_GHC_TEMP_FOLDER="$TERMUX_COMMON_CACHEDIR/$GHC_PREFIX"
	local TERMUX_GHC_TAR="$TERMUX_GHC_TEMP_FOLDER.tar.xz"
	local TERMUX_GHC_RUNTIME_FOLDER

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == false ]]; then

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == true ]]; then
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/${GHC_PREFIX}-runtime"
		else
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
		fi

		export PATH="${TERMUX_GHC_RUNTIME_FOLDER}/bin:${PATH}"

		[[ -d "${TERMUX_GHC_RUNTIME_FOLDER}" ]] && return

		local CHECKSUMS
		CHECKSUMS="$(
			cat <<-EOF
				aarch64:566b069f26854e6a93d1a57569ea9749f71185fb017e2477d35157a80c418edb
				arm:309ff35898983f3ae9c5f3ef07d30b13ed1446a92619740b2e0d1757ec6eef0d
				i686:fbf81b7bf83929bad98861478dc2f112873fd3f29bfcb54265163baff82c103c
				x86_64:39d4781ddcc99b4046fcff3d9e2799a0d6c40c8cbe46d87ff2cc502227285764
			EOF
		)"

		termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v${TERMUX_GHC_VERSION}/ghc-${TERMUX_GHC_VERSION}-${TERMUX_HOST_PLATFORM/arm/armv7a}.tar.xz" \
			"${TERMUX_GHC_TAR}" \
			"$(echo "${CHECKSUMS}" | grep -w "${TERMUX_ARCH}" | cut -d ':' -f 2)"

		mkdir -p "${TERMUX_GHC_RUNTIME_FOLDER}" "${TERMUX_GHC_TEMP_FOLDER}"
		tar -xf "${TERMUX_GHC_TAR}" -C "${TERMUX_GHC_TEMP_FOLDER}" --strip-components=1

		(
			set -e
			cd "$TERMUX_GHC_TEMP_FOLDER"

			export CONF_CC_OPTS_STAGE2="$CFLAGS $CPPFLAGS"
			export CONF_GCC_LINKER_OPTS_STAGE2="$LDFLAGS"
			export CONF_CXX_OPTS_STAGE2="$CXXFLAGS"

			./configure \
				--prefix="$TERMUX_GHC_RUNTIME_FOLDER" \
				--host="${TERMUX_HOST_PLATFORM/arm/armv7a}"
			make install
		) &>/dev/null

		rm -rf "${TERMUX_GHC_TAR}" "$TERMUX_GHC_TEMP_FOLDER"
	else
		if [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ||
			[[ "${TERMUX_APP_PACKAGE_MANAGER}" == "pacman" ]] && ! "$(pacman -Q ghc 2>/dev/null)"; then
			echo "Package 'ghc' is not installed."
			exit 1
		fi
	fi
}
