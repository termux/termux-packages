# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc_cross_compiler() {
	local TERMUX_GHC_VERSION="8.10.7"
	local GHC_PREFIX="ghc-cross-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}"
	if [ "${TERMUX_ON_DEVICE_BUILD}" = "false" ]; then
		local TERMUX_GHC_RUNTIME_FOLDER

		if [ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]; then
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/${GHC_PREFIX}-runtime"
		else
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
		fi

		local TERMUX_GHC_TAR="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}.tar.xz"

		export PATH="${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}:${TERMUX_GHC_RUNTIME_FOLDER}/bin:${PATH}"

		test -d "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}" ||
			termux_error_exit "Package 'ghc-libs' is not installed. It is required by GHC cross-compiler." \
				"You should specify it in 'TERMUX_PKG_BUILD_DEPENDS'."

		# Register dependency haskell packages with termux-ghc-pkg.
		IFS=',' read -r -a DEP <<<"${TERMUX_PKG_DEPENDS},${TERMUX_PKG_BUILD_DEPENDS}"
		for dep in "${DEP[@]}"; do
			if [[ "${dep}" == haskell-* ]]; then
				echo "Dependency '${pkg}' is a haskell package, registering it with ghc-pkg..."
				sed "s|${TERMUX_PREFIX}/bin/ghc-pkg|$(command -v termux-ghc-pkg)|g" \
					"${TERMUX_PREFIX}/share/haskell/register/${pkg}.sh" | sh
				termux-ghc-pkg recache
				# NOTE: Above command rewrites a cache file at "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/package.conf.d".
			# Since it is done after timestamp creation, we need to remove it in massage step.
			fi
		done

		[ -d "${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}" ] && return

		local CHECKSUMS="$(
			cat <<-EOF
				aarch64:1f0fb1579f0afa53a67bb2f20a8c270e971a955a1e508377628d6fe22e2254e1
				arm:e79b1819537b49592cae9009d18baf610217bbc6c553c2f02d1bc8fe3de63704
				i686:5ffd15446e1540fb2a75c10b97d5b426037540c024720337a7f9e297e599a749
				x86_64:f78049742d0169054f289168833d35b06b464330b9236b13f3b8f38ddc87505b
			EOF
		)"

		termux_download "https://github.com/MrAdityaAlok/ghc-cross-tools/releases/download/ghc-v${TERMUX_GHC_VERSION}/ghc-cross-bin-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}.tar.xz" \
			"${TERMUX_GHC_TAR}" \
			"$(echo "${CHECKSUMS}" | grep -w "${TERMUX_ARCH}" | cut -d ':' -f 2)"

		mkdir -p "${TERMUX_GHC_RUNTIME_FOLDER}"

		tar -xf "${TERMUX_GHC_TAR}" -C "${TERMUX_GHC_RUNTIME_FOLDER}"

		local _HOST="${TERMUX_HOST_PLATFORM}"
		[ "${TERMUX_ARCH}" = "arm" ] && _HOST="armv7a-linux-androideabi"

		# Replace ghc settings with settings of the cross compiler.
		sed "s|\$topdir/bin/unlit|${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/bin/unlit|g" \
			"${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/settings" > \
			"${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/settings"
		# NOTE: Above command edits file in $TERMUX_PREFIX after timestamp is created,
		# so we need to remove it in massage step.

		for tool in ghc ghc-pkg hsc2hs hp2ps ghci; do
			sed -i "s|\$executablename|${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/bin/${tool}|g" \
				"${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}/termux-${tool}"
		done

		# GHC ships with old version, we use our own.
		termux-ghc-pkg unregister Cabal
		# NOTE: Above command rewrites a cache file at "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/package.conf.d".
		# Since it is done after timestamp creation, we need to remove it in massage step.

		rm "${TERMUX_GHC_TAR}"
	else

		if [[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "debian" && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "pacman" && ! "$(pacman -Q ghc 2>/dev/null)" ]]; then
			echo "Package 'ghc' is not installed."
			exit 1
		else
			local ON_DEVICE_GHC_BIN="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
			export PATH="${ON_DEVICE_GHC_BIN}:${PATH}"
			[ -d "${ON_DEVICE_GHC_BIN}" ] && return

			mkdir -p "${ON_DEVICE_GHC_BIN}"
			for tool in ghc ghc-pkg hsc2hs hp2ps ghci; do
				ln -sf "${TERMUX_PREFIX}/bin/${tool}" "${ON_DEVICE_GHC_BIN}/termux-${tool}"
			done
		fi
	fi
}
