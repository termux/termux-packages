TERMUX_PKG_HOMEPAGE=https://www.dyne.org/software/frei0r/
TERMUX_PKG_DESCRIPTION="Minimalistic plugin API for video effects"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.3"
TERMUX_PKG_SRCURL=https://github.com/dyne/frei0r/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dcf290cdfbe583d007c300aa7733c9350ed957a0e30ca897a5c098875b8aa5dc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcairo"
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DWITHOUT_GAVL=ON
-DWITHOUT_OPENCV=ON
"

termux_pkg_auto_update() {
	local latest_tag="$(termux_github_api_get_tag "${TERMUX_PKG_SRCURL}")"
	[[ -z "${latest_tag}" ]] && termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	termux_pkg_upgrade_version "${latest_tag#v}"
}
