TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="This is the MATE calculator application"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-calc/releases/download/v$TERMUX_PKG_VERSION/mate-calc-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=804b125d1e2864b1e74af816da9b2ab8b19472b9af974437ee7355ada5e628f5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libmpc, libxml2"
TERMUX_PKG_BUILD_DEPENDS="mate-common"

termux_step_pre_configure() {
	# prevents error: unknown type name 'ulong'
	CFLAGS+=" -Dulong=u_long"
}
