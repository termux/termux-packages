# Utility script to setup jailbreak-cabal script. It is used by haskell build system to remove version
# constraints in cabal files.
termux_setup_jailbreak_cabal() {
	if [ "${TERMUX_ON_DEVICE_BUILD}" = "false" ]; then
		local TERMUX_JAILBREAK_VERSION=1.3.5
		local TERMUX_JAILBREAK_TMPDIR="${TERMUX_COMMON_CACHEDIR}/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}"
		local TERMUX_JAILBREAK_TAR="${TERMUX_JAILBREAK_TMPDIR}.tar.gz"
		local TERMUX_JAILBREAK_RUNTIME_FOLDER

		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			TERMUX_JAILBREAK_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}-runtime"
		else
			TERMUX_JAILBREAK_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}-runtime"
		fi

		export PATH="${TERMUX_JAILBREAK_RUNTIME_FOLDER}/bin:${PATH}"

		[ -d "${TERMUX_JAILBREAK_RUNTIME_FOLDER}" ] && return

		termux_download "https://hackage.haskell.org/package/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}/jailbreak-cabal-${TERMUX_JAILBREAK_VERSION}.tar.gz" \
			"${TERMUX_JAILBREAK_TAR}" \
			"8d1fce7dd9b755367f8236d91c94c5bb212a5fea9d8bc32696774cff5e7f4188"

		mkdir -p "${TERMUX_JAILBREAK_RUNTIME_FOLDER}" "${TERMUX_JAILBREAK_TMPDIR}"
		tar xf "${TERMUX_JAILBREAK_TAR}" -C "${TERMUX_JAILBREAK_TMPDIR}" --strip-components=1
		(
			cd "${TERMUX_JAILBREAK_TMPDIR}"
			termux_setup_ghc
			runhaskell Setup configure \
				--prefix="${TERMUX_JAILBREAK_RUNTIME_FOLDER}" \
				--enable-shared \
				--enable-executable-dynamic \
				--ghc-options=-dynamic
			runhaskell Setup build
			runhaskell Setup install
		)

		rm "${TERMUX_JAILBREAK_TAR}"
		rm -Rf "${TERMUX_JAILBREAK_TMPDIR}"
	else
		if [[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "debian" && "$(dpkg-query -W -f '${db:Status-Status}\n' jailbreak-cabal 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "pacman" && ! "$(pacman -Q jailbreak-cabal 2>/dev/null)" ]]; then
			echo "Package 'jailbreak-cabal' is not installed."
			exit 1
		fi
	fi
}
