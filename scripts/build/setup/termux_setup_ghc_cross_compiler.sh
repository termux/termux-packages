# shellcheck shell=bash
__termux_haskell_register_packages() {
	# Register dependency haskell packages with termux-ghc-pkg.
	IFS=',' read -r -a DEP <<<"$(echo "${TERMUX_PKG_DEPENDS},${TERMUX_PKG_BUILD_DEPENDS}" | tr -d ' ')"
	for dep in "${DEP[@]}"; do
		if [[ "${dep/haskell-/}" != "${dep}" ]]; then
			echo "Dependency '${dep}' is a haskell package, registering it with ghc-pkg..."
			sed "s|${TERMUX_PREFIX}/bin/ghc-pkg|$(command -v termux-ghc-pkg)|g" \
				"${TERMUX_PREFIX}/share/haskell/register/${dep}.sh" | sh
			termux-ghc-pkg recache
			# NOTE: Above command rewrites a cache file at
			# "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/package.conf.d". Since it is done after
			# timestamp creation, we need to remove it in massage step.
		fi
	done
}

__termux_haskell_setup_build_script() {
	local runtime_folder="$1"

	if ! command -v termux-ghc-setup &>/dev/null; then
		if [ "${TERMUX_ON_DEVICE_BUILD}" = false ]; then
			local build_type=""
			if ! cat "${TERMUX_PKG_SRCDIR}"/*.cabal | grep -wq "^[bB]uild-type:" ||
				cat "${TERMUX_PKG_SRCDIR}"/*.cabal | grep -wq '^[bB]uild-type:\s*[Ss]imple$'; then
				build_type="simple"
			elif cat "${TERMUX_PKG_SRCDIR}"/*.cabal | grep -wq '^[bB]uild-type:\s*[Cc]onfigure$'; then
				build_type="configure"
			elif cat "${TERMUX_PKG_SRCDIR}"/*.cabal | grep -wq '^[bB]uild-type:\s*[Mm]ake$'; then
				build_type="make"
			else
				# Now, it must be a custom build.
				# Compile custom Setup script with GHC and make it available in PATH.
				termux_setup_ghc
				ghc --make "${TERMUX_PKG_SRCDIR}/Setup" -o "${runtime_folder}/bin/termux-ghc-setup"
				return
			fi

			ln -sf "$runtime_folder/bin/${build_type}_setup" \
				"$runtime_folder/bin/termux-ghc-setup"
		else
			# On device, we always have ghc installed. So, always compile Setup script.
			ghc --make "${TERMUX_PKG_SRCDIR}/Setup" -o "${runtime_folder}/bin/termux-ghc-setup"
		fi
	fi
}

# Utility function to setup a GHC cross-compiler toolchain targeting Android.
termux_setup_ghc_cross_compiler() {
	local TERMUX_GHC_VERSION="8.10.7"
	local GHC_PREFIX="ghc-cross-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}"
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		local TERMUX_GHC_RUNTIME_FOLDER

		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_SCRIPTDIR}/build-tools/${GHC_PREFIX}-runtime"
		else
			TERMUX_GHC_RUNTIME_FOLDER="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
		fi

		local TERMUX_GHC_TAR="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}.tar.xz"

		export PATH="${TERMUX_GHC_RUNTIME_FOLDER}/bin:${PATH}"

		test -d "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}" ||
			termux_error_exit "Package 'ghc-libs' is not installed. It is required by GHC cross-compiler." \
				"You should specify it in 'TERMUX_PKG_BUILD_DEPENDS'."

		if [[ -d "${TERMUX_GHC_RUNTIME_FOLDER}" ]]; then
			__termux_haskell_setup_build_script "${TERMUX_GHC_RUNTIME_FOLDER}"
			__termux_haskell_register_packages
			return
		fi

		local CHECKSUMS
		CHECKSUMS="$(
			cat <<-EOF
				aarch64:0912e8c6a8f4b362198c26129bb55f8e76edfcfbf38bfaf8b025a46429e6a887
				arm:4f9acf98ee44eaebec6bce915507a934d1f880dd4c7ee679c075644e3bc41f78
				i686:289a04baa67b8cbef401aebf8f5ffef90735e5a5b6e00ce39a50b82c134fe51b
				x86_64:b43b4c8b80210c2b17ad4547d6d007163052edbd662495e0010b1c9b17d4f865
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
			[[ "${tool}" == "ghci" ]] && _tool="ghc"
			sed -i "s|\$executablename|${TERMUX_GHC_RUNTIME_FOLDER}/lib/ghc-${TERMUX_GHC_VERSION}/bin/${_tool}|g" \
				"${TERMUX_GHC_RUNTIME_FOLDER}/bin/termux-${tool}"
		done

		# GHC ships with old version, we use our own.
		termux-ghc-pkg unregister Cabal
		# NOTE: Above command rewrites a cache file at
		# "${TERMUX_PREFIX}/lib/ghc-${TERMUX_GHC_VERSION}/package.conf.d". Since it is done after
		# timestamp creation, we need to remove it in massage step.

		__termux_haskell_setup_build_script "${TERMUX_GHC_RUNTIME_FOLDER}"
		__termux_haskell_register_packages

		rm "${TERMUX_GHC_TAR}"
	else

		if [[ "${TERMUX_MAIN_PACKAGE_FORMAT}" == "debian" ]] && "$(dpkg-query -W -f '${db:Status-Status}\n' ghc 2>/dev/null)" != "installed" ||
			[[ "${TERMUX_MAIN_PACKAGE_FORMAT}" == "pacman" ]] && ! "$(pacman -Q ghc 2>/dev/null)"; then
			echo "Package 'ghc' is not installed."
			exit 1
		else
			local ON_DEVICE_GHC_RUNTIME="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}-runtime"
			export PATH="${ON_DEVICE_GHC_RUNTIME}/bin:${PATH}"

			if [[ -d "${ON_DEVICE_GHC_RUNTIME}" ]]; then
				__termux_haskell_setup_build_script "${ON_DEVICE_GHC_RUNTIME}"
				__termux_haskell_register_packages
				return
			fi

			mkdir -p "${ON_DEVICE_GHC_RUNTIME}"/bin
			for tool in ghc ghc-pkg hsc2hs hp2ps ghci; do
				ln -sf "${TERMUX_PREFIX}/bin/${tool}" "${ON_DEVICE_GHC_RUNTIME}/bin/termux-${tool}"
			done
			__termux_haskell_setup_build_script "${ON_DEVICE_GHC_RUNTIME}"
			__termux_haskell_register_packages
		fi
	fi
}
