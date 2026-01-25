TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Extension for Caja which allows the user to add arbitrary programs to be launched"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/caja-actions/releases/download/v$TERMUX_PKG_VERSION/caja-actions-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=310d39488e707fad848959a0a800b6154f4498dfddaeff5af49e4db35d0bea4d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="caja, libgtop"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, glib, mate-common"

termux_step_pre_configure() {
	# Fixes:
	# CANNOT LINK EXECUTABLE "caja-actions-config-tool":
	# library "libna-core.so" not found: needed by main executable
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/caja-actions"
}
