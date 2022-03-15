# shellcheck shell=bash
termux_setup_cabal() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		local TERMUX_CABAL_VERSION=3.6.2.0
		local TERMUX_CABAL_TAR="${TERMUX_COMMON_CACHEDIR}/cabal-${TERMUX_CABAL_VERSION}.tar.xz"

		local TERMUX_CABAL_RUNTIME_FOLDER

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
			TERMUX_CABAL_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/cabal-${TERMUX_CABAL_VERSION}-runtime"
		else
			TERMUX_CABAL_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/cabal-${TERMUX_CABAL_VERSION}-runtime"
		fi

		export PATH="${TERMUX_CABAL_RUNTIME_FOLDER}:${PATH}"

		[[ -d "${TERMUX_CABAL_RUNTIME_FOLDER}" ]] && return

		termux_download "https://github.com/MrAdityaAlok/ghc-cross-tools/releases/download/cabal-install-v${TERMUX_CABAL_VERSION}/cabal-install-${TERMUX_CABAL_VERSION}.tar.xz" \
			"${TERMUX_CABAL_TAR}" \
			"f433e99cb3ff85239bd633f2ae2a370bfb7103f9db80e38199e0fda27897bdfe"

		mkdir -p "${TERMUX_CABAL_RUNTIME_FOLDER}"
		tar xf "${TERMUX_CABAL_TAR}" -C "${TERMUX_CABAL_RUNTIME_FOLDER}"
		rm "${TERMUX_CABAL_TAR}"

		cabal update

	else
		if [[ "${TERMUX_MAIN_PACKAGE_FORMAT}" == "debian" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' cabal-install 2>/dev/null)" != "installed" ||
			[[ "${TERMUX_MAIN_PACKAGE_FORMAT}" == "pacman" ]] && ! "$(pacman -Q cabal-install 2>/dev/null)"; then
			echo "Package 'cabal-install' is not installed."
			exit 1
		fi
	fi
}
