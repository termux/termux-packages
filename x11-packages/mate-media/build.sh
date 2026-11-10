TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="MATE Media Tools"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.0"
TERMUX_PKG_SRCURL="https://github.com/mate-desktop/mate-media/releases/download/v$TERMUX_PKG_VERSION/mate-media-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=adeeac098b07c708736edd023617339f3019f02bb7a60c52cb68164a64d6e4b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcanberra, libmatemixer, mate-desktop, mate-panel, gettext"
TERMUX_PKG_BUILD_DEPENDS="autoconf-archive, mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
"
