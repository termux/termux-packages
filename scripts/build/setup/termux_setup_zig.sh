# shellcheck shell=bash disable=SC2155
termux_setup_zig() {
	# TODO need to figure out if zig supports android targets
	export ZIG_TARGET_NAME="${TERMUX_ARCH}-linux-musl"
	case "${TERMUX_ARCH}" in
	arm) ZIG_TARGET_NAME="arm-linux-musleabihf" ;;
	i686) ZIG_TARGET_NAME="x86-linux-musl" ;;
	esac

	if [[ -z "${TERMUX_ZIG_VERSION-}" ]]; then
		TERMUX_ZIG_VERSION=$(. "${TERMUX_SCRIPTDIR}/packages/zig/build.sh"; echo ${TERMUX_PKG_VERSION})
	fi

	local ZIG_TXZ_SHA256
	case "${TERMUX_ZIG_VERSION}" in
	0.15.2) ZIG_TXZ_SHA256=02aa270f183da276e5b5920b1dac44a63f1a49e55050ebde3aecc9eb82f93239 ;;
	0.15.1) ZIG_TXZ_SHA256=c61c5da6edeea14ca51ecd5e4520c6f4189ef5250383db33d01848293bfafe05 ;;
	0.14.1) ZIG_TXZ_SHA256=24aeeec8af16c381934a6cd7d95c807a8cb2cf7df9fa40d359aa884195c4716c ;;
	0.14.0) ZIG_TXZ_SHA256=473ec26806133cf4d1918caf1a410f8403a13d979726a9045b421b685031a982 ;;
	0.13.0) ZIG_TXZ_SHA256=d45312e61ebcc48032b77bc4cf7fd6915c11fa16e4aad116b66c9468211230ea ;;
	0.12.0) ZIG_TXZ_SHA256=c7ae866b8a76a568e2d5cfd31fe89cdb629bdd161fdd5018b29a4a0a17045cad ;;
	0.11.0) ZIG_TXZ_SHA256=2d00e789fec4f71790a6e7bf83ff91d564943c5ee843c5fd966efc474b423047 ;;
	0.9.1 ) ZIG_TXZ_SHA256=be8da632c1d3273f766b69244d80669fe4f5e27798654681d77c992f17c237d7 ;;
	*) termux_error_exit "Please add ${TERMUX_ZIG_VERSION} archive checksum to termux_setup_zig and update patches in packages/zig" ;;
	esac

	# Zig switched the target format for its tarballs in 0.14.1
	local ZIG_TXZ_URL
	case "${TERMUX_ZIG_VERSION}" in
		0.9.1|0.10.0|0.11.0|0.12.0|0.13.0|0.14.0) # Old format: `zig-${platform}-${arch}-${version}.tar.xz`
			ZIG_TXZ_URL=https://ziglang.org/download/${TERMUX_ZIG_VERSION}/zig-linux-x86_64-${TERMUX_ZIG_VERSION}.tar.xz
		;;
		*) # New format: `zig-${arch}-${platform}-${version}.tar.xz`
			ZIG_TXZ_URL=https://ziglang.org/download/${TERMUX_ZIG_VERSION}/zig-x86_64-linux-${TERMUX_ZIG_VERSION}.tar.xz
		;;
	esac

	local ZIG_TXZ_FILE=${TERMUX_PKG_TMPDIR}/zig-${TERMUX_ZIG_VERSION}.tar.xz
	local ZIG_FOLDER=${TERMUX_COMMON_CACHEDIR}/zig-${TERMUX_ZIG_VERSION}
	if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
		ZIG_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/zig-${TERMUX_ZIG_VERSION}
	fi

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if [[ -z "$(command -v zig)" ]]; then
			cat <<- EOL
			Package 'zig' is not installed.
			You can install it with

			pkg install zig
			EOL
			exit 1
		fi
		local ZIG_VERSION=$(zig version)
		if [[ "${TERMUX_ZIG_VERSION}" != "${ZIG_VERSION}" ]]; then
			cat <<- EOL >&2
			WARN: On device build with old zig version is not possible!
			TERMUX_ZIG_VERSION = ${TERMUX_ZIG_VERSION}
			ZIG_VERSION        = ${ZIG_VERSION}
			EOL
		fi
		return
	fi

	if [[ ! -x "${ZIG_FOLDER}/zig" ]]; then
		mkdir -p "${ZIG_FOLDER}"
		termux_download "${ZIG_TXZ_URL}" "${ZIG_TXZ_FILE}" "${ZIG_TXZ_SHA256}"
		tar -xf "${ZIG_TXZ_FILE}" -C "${ZIG_FOLDER}" --strip-components=1

		if [[ -n "$(find "${TERMUX_SCRIPTDIR}/packages/zig/${TERMUX_ZIG_VERSION}" -name 'zig-*.patch')" ]]; then
			echo "termux_setup_zig: Applying patches from packages/zig/${TERMUX_ZIG_VERSION}"
			local p
			for p in "${TERMUX_SCRIPTDIR}"/packages/zig/${TERMUX_ZIG_VERSION}/zig-*.patch; do
				patch -d "${ZIG_FOLDER}" -p2 -i "${p}"
			done
		fi
	fi

	export PATH="${ZIG_FOLDER}:${PATH}"
	if [[ -z "$(command -v zig)" ]]; then
		termux_error_exit "termux_setup_zig: No zig executable found!"
	fi
}
