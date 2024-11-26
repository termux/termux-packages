TERMUX_PKG_HOMEPAGE=https://apt-team.pages.debian.net/python-apt/
TERMUX_PKG_DESCRIPTION="Python bindings for APT"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.9.1"
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/p/python-apt/python-apt_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f7f197f47038fda0e5db78ced499cca86b79aaa646e3cf04b80aa8a837a88cf5
TERMUX_PKG_DEPENDS="apt, libandroid-support, libc++, python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"

termux_pkg_auto_update() {
	# based on scripts/updates/api/termux_repology_api_get_latest_version.sh
	local TERMUX_REPOLOGY_DATA_FILE=$(mktemp)
	python3 "${TERMUX_SCRIPTDIR}"/scripts/updates/api/dump-repology-data \
		"${TERMUX_REPOLOGY_DATA_FILE}" "${TERMUX_PKG_NAME}" >/dev/null || \
		echo "{}" > "${TERMUX_REPOLOGY_DATA_FILE}"
	local latest_version=$(jq -r --arg packageName "${TERMUX_PKG_NAME}" '.[$packageName]' < "${TERMUX_REPOLOGY_DATA_FILE}")
	if [[ "${latest_version}" == "null" ]]; then
		latest_version="${TERMUX_PKG_VERSION}"
	fi
	if [[ "${latest_version}" == "${TERMUX_PKG_VERSION}" ]]; then
		echo "INFO: No update needed. Already at version '${TERMUX_PKG_VERSION}'."
		rm -f "${TERMUX_REPOLOGY_DATA_FILE}"
		return
	fi
	rm -f "${TERMUX_REPOLOGY_DATA_FILE}"
	termux_pkg_upgrade_version "${latest_version}"
}

termux_step_pre_configure() {
	export DEBVER="${TERMUX_PKG_VERSION#*:}"
}
