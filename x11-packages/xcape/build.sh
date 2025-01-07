TERMUX_PKG_HOMEPAGE=https://github.com/alols/xcape
TERMUX_PKG_DESCRIPTION="Linux utility to configure modifier keys to act as other keys when pressed and released on their own."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=https://github.com/alols/xcape/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a27ed884fd94f03058af65a39edfe3af3f2f8fbb76ba9920002a76be07fb2821
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="libx11,libxtst"
TERMUX_PKG_EXTRA_MAKE_ARGS="PREFIX=$TERMUX_PREFIX"
