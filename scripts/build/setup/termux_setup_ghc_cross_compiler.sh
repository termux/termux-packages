# Utility function to setup a GHC cross-compiler toolchain targeting Android.
# This function should be called before termux_create_timestamp. By default,
# it will be called automatically by `termux_step_get_dependencies` if `ghc-libs` or `ghc-libs-static`
# is in dependency of the package.
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

		local GHC_BIN="${TERMUX_GHC_RUNTIME_FOLDER}/${TERMUX_ARCH}/bin"
		local TERMUX_GHC_TAR="${TERMUX_COMMON_CACHEDIR}/${GHC_PREFIX}.tar.xz"

		export PATH="${GHC_BIN}:${PATH}"

		[ -d "${GHC_BIN}" ] && return

		local CHECKSUMS="$(
			cat <<-EOF
				aarch64:f0324496eb5c072465f614a03492743ae28270d1844f08129ebc2b2f3148d331
				arm:c7e2850d2b6e0905d7f68eb1be7119759c2e50ef0bff7243e58b86172d710a80
				i686:86d7b38371b9098425b1abbffa667237f2624e079e3c65636b78f1b737e74891
				x86_64:2704c3f8d8bea7e2c7fc9288fd3a197aca889123fa7283e44492b7e0197853b0
			EOF
		)"

		termux_download "https://github.com/MrAdityaAlok/ghc-cross-tools/releases/download/ghc-v${TERMUX_GHC_VERSION}/ghc-cross-bin-${TERMUX_GHC_VERSION}-${TERMUX_ARCH}.tar.xz" \
			"${TERMUX_GHC_TAR}" \
			"$(echo "${CHECKSUMS}" | grep -w "${TERMUX_ARCH}" | cut -d ':' -f 2)"

		(
			if tar -tf "${TERMUX_GHC_TAR}" | grep "^./$" >/dev/null; then
				# Strip prefixed ./, to avoid possible
				# permission errors from tar
				tar -xf "${TERMUX_GHC_TAR}" --strip-components=1 \
					--no-overwrite-dir -C /
			else
				tar -xf "${TERMUX_GHC_TAR}" --no-overwrite-dir -C /
			fi
		)

		local _HOST="${TERMUX_HOST_PLATFORM}"
		[ "${TERMUX_ARCH}" = "arm" ] && _HOST="armv7a-linux-androideabi"

		mkdir -p "${GHC_BIN}"
		for tool in ghc ghc-pkg hsc2hs hp2ps; do
			ln -sf "${TERMUX_PREFIX}/bin/${_HOST}-${tool}" "${GHC_BIN}/termux-${tool}"
		done

		for f in "${TERMUX_PREFIX}"/bin/"${_HOST}"-*; do
			sed -i -e "s|^#!${TERMUX_PREFIX}/bin/sh|#!/usr/bin/sh|" \
				-e "s|${_HOST}-ghc-${TERMUX_GHC_VERSION}|ghc-${TERMUX_GHC_VERSION}|g" \
				"$f"
		done

		# GHC ships with old version, we use our own.
		termux-ghc-pkg unregister Cabal

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
			for tool in ghc ghc-pkg hsc2hs hp2ps; do
				ln -sf "${TERMUX_PREFIX}/bin/${tool}" "${ON_DEVICE_GHC_BIN}/termux-${tool}"
			done
		fi
	fi
}
