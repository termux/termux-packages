# shellcheck shell=bash
# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc_cross_compiler() {
	local TERMUX_GHC_VERSION=9.12.1
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

		[[ -d "${TERMUX_GHC_RUNTIME_FOLDER}" ]] && return

		local CHECKSUMS
		CHECKSUMS="$(
			cat <<-EOF
				aarch64:ff897fbcda680ca20be99a6f87a90a429ea81eb0014da548e870f08b98313b2d
				arm:6f47eca3532f901730de8c21025d6f97d26cf7224bbf015fdbe0d53ff925c0ad
				i686:0872610a29a3de2efc17efe8ef33e0f8e357029125059bfdc486f95dbb96faf0
				x86_64:3085c5de58d2e9e4db69edfaac45f370773ba112faec68e6bf5d112fa80bb484
			EOF
		)"

		local host_platform="$TERMUX_HOST_PLATFORM"
		if [ "$TERMUX_ARCH" = "arm" ]; then
			host_platform="armv7a-linux-androideabi"
		fi

		termux_download "https://github.com/termux/ghc-cross-tools/releases/download/ghc-v${TERMUX_GHC_VERSION}/ghc-${TERMUX_GHC_VERSION}-${host_platform}.tar.xz" \
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
				--host="$host_platform"
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
