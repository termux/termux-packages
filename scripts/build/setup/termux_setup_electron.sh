# shellcheck shell=bash

termux_setup_electron() {
	local electron_major="${TERMUX_ELECTRON_MAJOR:-42}"
	local electron_host_tools="electron${electron_major}-host-tools"

	termux_setup_nodejs

	# npm refuses to work with these set
	unset PREFIX prefix

	case "${TERMUX_ARCH}" in
		aarch64) NPM_CONFIG_ARCH=arm64; TERMUX_ELECTRON_ARCH=arm64 ;;
		arm) NPM_CONFIG_ARCH=arm; TERMUX_ELECTRON_ARCH=armv7l ;;
		x86_64) NPM_CONFIG_ARCH=x64; TERMUX_ELECTRON_ARCH=x64 ;;
		*) termux_error_exit "Unsupported arch: ${TERMUX_ARCH}" ;;
	esac
	export NPM_CONFIG_ARCH TERMUX_ELECTRON_ARCH
	export npm_config_arch="${NPM_CONFIG_ARCH}"

	# shellcheck source=/dev/null
	TERMUX_ELECTRON_VERSION="$(. "${TERMUX_SCRIPTDIR}/x11-packages/${electron_host_tools}/build.sh"; echo "${TERMUX_PKG_VERSION}")"
	export TERMUX_ELECTRON_VERSION

	# Build native addons against the headers of Termux's Electron
	export npm_config_nodedir="${TERMUX_PREFIX}/opt/${electron_host_tools}/node_headers"
	export CXX="${CXX} -v -L${TERMUX_PREFIX}/lib"

	# The Electron binary can't be downloaded (glibc only, no armv7l).
	# Anything that asks for it gets an empty placeholder instead.
	export ELECTRON_SKIP_BINARY_DOWNLOAD=1
	TERMUX_ELECTRON_DIST="${TERMUX_PKG_TMPDIR}/electron-dist"
	export TERMUX_ELECTRON_DIST
	export ELECTRON_OVERRIDE_DIST_PATH="${TERMUX_ELECTRON_DIST}"
	rm -rf "${TERMUX_ELECTRON_DIST}"
	mkdir -p "${TERMUX_ELECTRON_DIST}"
	install -m755 /dev/null "${TERMUX_ELECTRON_DIST}/electron"

	local pinned_version
	if [[ -n "${1:-}" ]]; then
		pinned_version="$(jq -r '.devDependencies.electron // .dependencies.electron // "unknown"' "$1")"
		echo "${TERMUX_PKG_NAME} was built/tested against Electron ${pinned_version}; this build uses ${TERMUX_ELECTRON_VERSION} instead."
	fi
}
