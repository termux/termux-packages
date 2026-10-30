# shellcheck shell=bash

termux_setup_dart() {
	# Must match the version of the dart package, kernel files are not portable across versions.
	local TERMUX_DART_VERSION="${TERMUX_DART_VERSION:-3.13.7}"
	local TERMUX_DART_SHA256="eb99aed266efbcb615c6ae21c12f52cfe935b9f208bccc5fea7f64c21e867229"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		if ! command -v dart; then
			cat <<- EOL
			Package 'dart' is not installed.
			You can install it with

			pkg install dart
			EOL
			exit 1
		fi
		return
	fi

	local TERMUX_DART_DIR="${TERMUX_COMMON_CACHEDIR}/dart-${TERMUX_DART_VERSION}"
	if [[ "${TERMUX_PACKAGES_OFFLINE-false}" == "true" ]]; then
		TERMUX_DART_DIR="${TERMUX_SCRIPTDIR}/build-tools/dart-${TERMUX_DART_VERSION}"
	fi

	if [[ ! -x "${TERMUX_DART_DIR}/bin/dart" ]]; then
		local TERMUX_DART_URL="https://storage.googleapis.com/dart-archive/channels/stable/release/${TERMUX_DART_VERSION}/sdk/dartsdk-linux-x64-release.zip"
		local TERMUX_DART_ZIP="${TERMUX_PKG_TMPDIR}/dart-${TERMUX_DART_VERSION}.zip"
		termux_download "${TERMUX_DART_URL}" "${TERMUX_DART_ZIP}" "${TERMUX_DART_SHA256}"

		rm -rf "${TERMUX_DART_DIR}" "${TERMUX_PKG_TMPDIR}/dart-extracted"
		unzip -oq "${TERMUX_DART_ZIP}" -d "${TERMUX_PKG_TMPDIR}/dart-extracted"
		mkdir -p "$(dirname "${TERMUX_DART_DIR}")"
		mv -f "${TERMUX_PKG_TMPDIR}/dart-extracted/dart-sdk" "${TERMUX_DART_DIR}"
		rm -rf "${TERMUX_PKG_TMPDIR}/dart-extracted" "${TERMUX_DART_ZIP}"
	fi

	export PATH="${TERMUX_DART_DIR}/bin:${PATH}"
}
