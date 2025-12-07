TERMUX_PKG_HOMEPAGE=https://www.dyne.org/software/frei0r/
TERMUX_PKG_DESCRIPTION="Minimalistic plugin API for video effects"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dyne/frei0r/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=318ec4a3042c94a00a58fccdc1eb0d911f36a22beb3504d27aefcca4598f40b0
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
