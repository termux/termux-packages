# shellcheck shell=bash
termux_setup_cabal() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		local TERMUX_CABAL_VERSION=3.14.1.1
		local TERMUX_CABAL_TAR="${TERMUX_COMMON_CACHEDIR}/cabal-${TERMUX_CABAL_VERSION}.tar.xz"

		local TERMUX_CABAL_RUNTIME_FOLDER

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
			TERMUX_CABAL_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/cabal-${TERMUX_CABAL_VERSION}-runtime"
		else
			TERMUX_CABAL_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/cabal-${TERMUX_CABAL_VERSION}-runtime"
		fi

		export PATH="${TERMUX_CABAL_RUNTIME_FOLDER}:${PATH}"
		export TERMUX_CABAL_CONFIG="$TERMUX_CABAL_RUNTIME_FOLDER/cabal.config"

		[[ -d "${TERMUX_CABAL_RUNTIME_FOLDER}" ]] && return

		termux_download "https://downloads.haskell.org/~cabal/cabal-install-${TERMUX_CABAL_VERSION}/cabal-install-${TERMUX_CABAL_VERSION}-x86_64-linux-ubuntu22_04.tar.xz" \
			"${TERMUX_CABAL_TAR}" \
			773633b5fff7f26abd6d9388b4ab7ef35b0cd544612ec34ab91ef9bc24438619

		mkdir -p "${TERMUX_CABAL_RUNTIME_FOLDER}"
		tar xf "${TERMUX_CABAL_TAR}" -C "${TERMUX_CABAL_RUNTIME_FOLDER}"
		rm "${TERMUX_CABAL_TAR}"

		cabal update

		# Configuration:

		local repo="hackage.haskell.org"

		cat <<-EOF >"$TERMUX_CABAL_CONFIG"
			repository hackage.haskell.org
			 url: https://$repo/

			remote-repo-cache: $HOME/.cache/cabal/packages
			executable-stripping: True
			configure-option: --host=$TERMUX_HOST_PLATFORM
			tests: False
			build-summary: $HOME/.cache/cabal/logs/build.log
			remote-build-reporting: none
			jobs: $TERMUX_PKG_MAKE_PROCESSES

			program-locations
			 strip-location: $(command -v "$STRIP")

			program-default-options
			 $([[ "$TERMUX_ON_DEVICE_BUILD" == false ]] && printf "%s" "hsc2hs-options: --cross-compile")
		EOF
	else
		if [[ "${TERMUX_APP_PACKAGE_MANAGER}" == "apt" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' cabal-install 2>/dev/null)" != "installed" ||
			[[ "${TERMUX_APP_PACKAGE_MANAGER}" == "pacman" ]] && ! "$(pacman -Q cabal-install 2>/dev/null)"; then
			echo "Package 'cabal-install' is not installed."
			exit 1
		fi
	fi
}
