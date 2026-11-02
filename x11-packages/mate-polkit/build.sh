TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="MATE polkit authentication agent"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION="1.28.1"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-polkit/releases/download/v${TERMUX_PKG_VERSION}/mate-polkit-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=350a1dd0a8ed6a2c9c183cff2a21f394299e968fcc6ae2e8c93c565dae604ae8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libpolkit"
TERMUX_PKG_BUILD_DEPENDS="mate-common"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
--disable-accountsservice
--disable-appindicator
"
