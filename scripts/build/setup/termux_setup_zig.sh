# shellcheck shell=bash disable=SC2155
termux_setup_zig() {
	local ZIG_VERSION=0.11.0
	local ZIG_TXZ_URL=https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz
	local ZIG_TXZ_SHA256=2d00e789fec4f71790a6e7bf83ff91d564943c5ee843c5fd966efc474b423047
	local ZIG_TXZ_FILE=${TERMUX_PKG_TMPDIR}/zig-${ZIG_VERSION}.tar.xz
	local ZIG_FOLDER=${TERMUX_COMMON_CACHEDIR}/zig-${ZIG_VERSION}
	if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
		ZIG_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/zig-${ZIG_VERSION}
	fi
	local ZIG_PKG_VERSION=$(. "${TERMUX_SCRIPTDIR}/packages/zig/build.sh"; echo ${TERMUX_PKG_VERSION})

	# zig 0.9.1 android triples never worked and uses musl
	export ZIG_TARGET_NAME="${TERMUX_ARCH}-linux-musl"
	case "${TERMUX_ARCH}" in
	arm) ZIG_TARGET_NAME="arm-linux-musleabihf" ;;
	i686) ZIG_TARGET_NAME="x86-linux-musl" ;;
	esac

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if [[ "$(cat "${TERMUX_BUILT_PACKAGES_DIRECTORY}/zig" 2>/dev/null)" != "${ZIG_PKG_VERSION}" && -z "$(command -v zig)" ]]; then
			cat <<- EOL
			Package 'zig' is not installed.
			You can install it with

			pkg install zig

			or build it from source with

			./build-package.sh zig
			EOL
			exit 1
		fi
		return
	fi

	if [[ ! -x "${ZIG_FOLDER}/zig" ]]; then
		mkdir -p "${ZIG_FOLDER}"
		termux_download "${ZIG_TXZ_URL}" "${ZIG_TXZ_FILE}" "${ZIG_TXZ_SHA256}"
		tar -xf "${ZIG_TXZ_FILE}" -C "${ZIG_FOLDER}" --strip-components=1

		echo "termux_setup_zig: Applying patches from packages/zig"
		for p in "${TERMUX_SCRIPTDIR}"/packages/zig/zig-*.patch; do
			patch -d "${ZIG_FOLDER}" -p2 -i "${p}"
		done
	fi

	export PATH="${ZIG_FOLDER}:${PATH}"
	if [[ -z "$(command -v zig)" ]]; then
		termux_error_exit "termux_setup_zig: No zig executable found!"
	fi
}
