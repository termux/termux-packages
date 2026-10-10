# shellcheck shell=bash

termux_setup_bun() {
	local TERMUX_BUN_VERSION="${TERMUX_BUN_VERSION:-1.4.3}"
	local TERMUX_BUN_SHA256="3e730528d89775f03f87f05c06787c4df4099d0a37f3f252e7b829cb23816e18"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if ! command -v bun; then
			cat <<- EOL
			Package 'bun' is not installed.
			You can install it with

			pkg install bun
			EOL
			exit 1
		fi
		return
	fi

	local TERMUX_BUN_DIR="${TERMUX_COMMON_CACHEDIR}/bun-${TERMUX_BUN_VERSION}"
	if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
		TERMUX_BUN_DIR="${TERMUX_SCRIPTDIR}/build-tools/bun-${TERMUX_BUN_VERSION}"
	fi

	if [[ ! -x "${TERMUX_BUN_DIR}/bun" ]]; then
		mkdir -p "${TERMUX_BUN_DIR}"
		local TERMUX_BUN_ZIP="${TERMUX_PKG_TMPDIR}/bun-${TERMUX_BUN_VERSION}.zip"
		termux_download \
			"https://github.com/oven-sh/bun/releases/download/bun-v${TERMUX_BUN_VERSION}/bun-linux-x64.zip" \
			"${TERMUX_BUN_ZIP}" \
			"${TERMUX_BUN_SHA256}"

		unzip -oq "${TERMUX_BUN_ZIP}" -d "${TERMUX_PKG_TMPDIR}/bun-linux-x64-extracted"
		mv -f "${TERMUX_PKG_TMPDIR}/bun-linux-x64-extracted/bun-linux-x64/bun" "${TERMUX_BUN_DIR}/bun"
		rm -rf "${TERMUX_PKG_TMPDIR}/bun-linux-x64-extracted" "${TERMUX_BUN_ZIP}"

		chmod 755 "${TERMUX_BUN_DIR}/bun"
		ln -sf bun "${TERMUX_BUN_DIR}/bunx"
	fi

	export PATH="${TERMUX_BUN_DIR}:${PATH}"
}
