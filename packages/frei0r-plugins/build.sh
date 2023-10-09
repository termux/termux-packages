TERMUX_PKG_HOMEPAGE=https://www.dyne.org/software/frei0r/
TERMUX_PKG_DESCRIPTION="Minimalistic plugin API for video effects"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.3.1"
TERMUX_PKG_SRCURL=https://github.com/dyne/frei0r/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dd6dbe49ba743421d8ced07781ca09c2ac62522beec16abf1750ef6fe859ddc9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcairo"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DWITHOUT_GAVL=ON -DWITHOUT_OPENCV=ON"

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	[[ -z "${latest_tag}" ]] && termux_error_exit "ERROR: Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag#v}"
}
