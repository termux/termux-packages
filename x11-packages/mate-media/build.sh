TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="MATE Media Tools"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-media/releases/download/v$TERMUX_PKG_VERSION/mate-media-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=bcdc102e22f63f55e63166d5c708e91c113570e6a30a874345a88609e83a9912
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcanberra, libmatemixer, mate-desktop, mate-panel, gettext"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
"
