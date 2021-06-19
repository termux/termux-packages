TERMUX_PKG_HOMEPAGE=https://dwm.suckless.org/
TERMUX_PKG_DESCRIPTION="A dynamic window manager for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=6.2
TERMUX_PKG_REVISION=20
TERMUX_PKG_SRCURL="http://dl.suckless.org/dwm/dwm-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=97902e2e007aaeaa3c6e3bed1f81785b817b7413947f1db1d3b62b8da4cd110e
TERMUX_PKG_DEPENDS="libx11, libxinerama, libxft, freetype, st, dmenu"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR/config.h" "config.h"
}
