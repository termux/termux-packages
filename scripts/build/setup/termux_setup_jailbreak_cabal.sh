# shellcheck shell=bash
# Utility script to setup jailbreak-cabal script. It is used by haskell build system to remove version
# constraints in cabal files.
termux_setup_jailbreak_cabal() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		local TERMUX_JAILBREAK_VERSION=1.3.5
		local TERMUX_JAILBREAK_TAR="${TERMUX_COMMON_CACHEDIR}/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}.tar.gz"
		local TERMUX_JAILBREAK_RUNTIME_FOLDER

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
			TERMUX_JAILBREAK_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}-runtime"
		else
			TERMUX_JAILBREAK_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}-runtime"
		fi

		export PATH="${TERMUX_JAILBREAK_RUNTIME_FOLDER}:${PATH}"

		[[ -d "${TERMUX_JAILBREAK_RUNTIME_FOLDER}" ]] && return

		termux_download "https://github.com/MrAdityaAlok/ghc-cross-tools/releases/download/jailbreak-cabal-v${TERMUX_JAILBREAK_VERSION}/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}.tar.xz" \
			"${TERMUX_JAILBREAK_TAR}" \
			"8d1a8b8fadf48f4abf42da025d5cf843bd68e1b3c18ecacdc0cd0c9bd470c64e"

		mkdir -p "${TERMUX_JAILBREAK_RUNTIME_FOLDER}"
		tar xf "${TERMUX_JAILBREAK_TAR}" -C "${TERMUX_JAILBREAK_RUNTIME_FOLDER}"

		rm "${TERMUX_JAILBREAK_TAR}"
	else
		if [[ "${TERMUX_MAIN_PACKAGE_FORMAT}" == "debian" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' jailbreak-cabal 2>/dev/null)" != "installed" ||
			[[ "${TERMUX_MAIN_PACKAGE_FORMAT}" = "pacman" ]] && ! "$(pacman -Q jailbreak-cabal 2>/dev/null)"; then
			echo "Package 'jailbreak-cabal' is not installed."
			exit 1
		fi
	fi
}
