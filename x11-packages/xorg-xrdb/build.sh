TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X server resource database utility"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SRCURL=https://www.x.org/archive/individual/app/xrdb-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=4f5d031c214ffb88a42ae7528492abde1178f5146351ceb3c05f3b8d5abee8b4
TERMUX_PKG_DEPENDS="libx11, libxmu"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-cpp=/usr/bin/cpp"
