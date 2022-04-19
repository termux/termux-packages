TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/lxde/
TERMUX_PKG_DESCRIPTION="Caching mechanism for freedesktop.org compliant menus"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=26
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/lxde/menu-cache-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=ed02eb459dcb398f69b9fa5bf4dd813020405afc84331115469cdf7be9273ec7
TERMUX_PKG_DEPENDS="glib, libfm-extra"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
