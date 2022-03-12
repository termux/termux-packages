__termux_haskell_register_packages() {
	# Register dependency haskell packages with termux-ghc-pkg.
	IFS=',' read -r -a DEP <<<"${TERMUX_PKG_DEPENDS},${TERMUX_PKG_BUILD_DEPENDS}"
	for dep in "${DEP[@]}"; do
		if [[ "${dep}" == haskell-* ]]; then
			echo "Dependency '${pkg}' is a haskell package, registering it with ghc-pkg..."
			sed "s|${TERMUX_PREFIX}/bin/ghc-pkg|$(command -v termux-ghc-pkg)|g" \
				"${TERMUX_PREFIX}/share/haskell/register/${pkg}.sh" | sh
			termux-ghc-pkg recache
			# NOTE: Above command rewrites a cache file at
			# "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/package.conf.d". Since it is done after
			# timestamp creation, we need to remove it in massage step.
		fi
	done
}

__termux_haskell_eval_custom_build() {
	local bin="$1"
	if ! $(cat "${TERMUX_PKG_SRCDIR}"/*.cabal | grep -wq "^[bB]uild-type:") ||
		$(cat "${TERMUX_PKG_SRCDIR}"/*.cabal | grep -wq '^[bB]uild-type:\s*[Ss]imple$'); then
		return
	fi
	# Now, it must be a custom build.
	# Compile custom Setup script with GHC and make it available in PATH.
	ghc --make "${TERMUX_PKG_SRCDIR}"/Setup -o "${bin}/termux-ghc-setup"
}

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

		export PATH="${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}:${PATH}"

		test -d "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}" ||
			termux_error_exit "Package 'ghc-libs' is not installed. It is required by GHC cross-compiler." \
				"You should specify it in 'TERMUX_PKG_BUILD_DEPENDS'."

		__termux_haskell_register_packages

		if [ -d "${TERMUX_GHC_RUNTIME_FOLDER}" ]; then
			__termux_haskell_eval_custom_build "${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}"
			return
		fi

		local CHECKSUMS="$(
			cat <<-EOF
				aarch64:abcb8c4e9d9c1ef3ce1e95049fe220c1947059c965a10baaa97a864666c17f4c
				arm:2bc44818f312bf7110deefbd23da0177f9e299519c22fe28b21ac24a2ea689a4
				i686:8e05cd5ffaeb1dc6dec824bf9ac42572f418ab95f86606e1dff91bcdca9e78b6
				x86_64:1976ec89e16294c8866ae7e2d564ce5bae8ebc62ac3dab1c2b8845f775b85feb
			EOF
		)"

		termux_download "https://github.com/MrAdityaAlok/ghc-cross-tools/releases/download/ghc-v${TERMUX_GHC_VERSION}/ghc-cross-bin-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}.tar.xz" \
			"${TERMUX_GHC_TAR}" \
			"$(echo "${CHECKSUMS}" | grep -w "${TERMUX_ARCH}" | cut -d ':' -f 2)"

		mkdir -p "${TERMUX_GHC_RUNTIME_FOLDER}"

		tar -xf "${TERMUX_GHC_TAR}" -C "${TERMUX_GHC_RUNTIME_FOLDER}"

		# Replace ghc settings with settings of the cross compiler.
		sed "s|\$topdir/bin/unlit|${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/bin/unlit|g" \
			"${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/settings" > \
			"${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/settings"
		# NOTE: Above command edits file in $TERMUX_PREFIX after timestamp is created,
		# so we need to remove it in massage step.

		for tool in ghc ghc-pkg hsc2hs hp2ps ghci; do
			_tool="${tool}"
			[ "${tool}" = "ghci" ] && _tool="ghc"
			sed -i "s|\$executablename|${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/bin/${_tool}|g" \
				"${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}/termux-${tool}"
		done

		# GHC ships with old version, we use our own.
		termux-ghc-pkg unregister Cabal
		# NOTE: Above command rewrites a cache file at
		# "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/package.conf.d". Since it is done after
		# timestamp creation, we need to remove it in massage step.

		__termux_haskell_eval_custom_build "${TERMUX_GHC_RUNTIME_FOLDER}/bin/${TERMUX_ARCH}"

		rm "${TERMUX_GHC_TAR}"
	else

		if [[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "debian" && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_MAIN_PACKAGE_FORMAT" = "pacman" && ! "$(pacman -Q ghc 2>/dev/null)" ]]; then
			echo "Package 'ghc' is not installed."
			exit 1
		else
			local ON_DEVICE_GHC_BIN="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
			export PATH="${ON_DEVICE_GHC_BIN}:${PATH}"

			__termux_haskell_register_packages

			if [ -d "${ON_DEVICE_GHC_BIN}" ]; then
				__termux_haskell_eval_custom_build "${ON_DEVICE_GHC_BIN}"
				return
			fi

			mkdir -p "${ON_DEVICE_GHC_BIN}"
			for tool in ghc ghc-pkg hsc2hs hp2ps ghci; do
				ln -sf "${TERMUX_PREFIX}/bin/${tool}" "${ON_DEVICE_GHC_BIN}/termux-${tool}"
			done
			__termux_haskell_eval_custom_build "${ON_DEVICE_GHC_BIN}"
			if ! command -v termux-ghc-setup &>/dev/null; then
				# Provide `termux-ghc-setup` on device.
				ghc --make "${TERMUX_SCRIPTDIR}"/scripts/build/haskell-build/default-setup.hs \
					-o "${ON_DEVICE_GHC_BIN}"/termux-ghc-setup
			fi
		fi
	fi
}
