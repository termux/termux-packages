TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/lxde/
TERMUX_PKG_DESCRIPTION="Caching mechanism for freedesktop.org compliant menus"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/lxde/menu-cache/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e8af90467df271c3c8700c840ca470ca2915699c6f213c502a87d74608748f08
TERMUX_PKG_DEPENDS="glib, libfm-extra"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
	autoreconf -fi
}
