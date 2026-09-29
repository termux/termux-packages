TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Simple window management tool"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.27.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-netbook/releases/download/v$TERMUX_PKG_VERSION/mate-netbook-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=b41a890c515e4dc2f51038fbc0fca65344a3b8551c7d7fd04b5470f18049df4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libfakekey, mate-panel, gettext"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
"
