TERMUX_PKG_HOMEPAGE=https://dwm.suckless.org/
TERMUX_PKG_DESCRIPTION="A dynamic window manager for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=6.3
TERMUX_PKG_SRCURL="http://dl.suckless.org/dwm/dwm-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=badaa028529b1fba1fd7f9a84f3b64f31190466c858011b53e2f7b70c6a3078d
TERMUX_PKG_DEPENDS="libx11, libxinerama, libxft, freetype, st, dmenu"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR/config.h" "config.h"
}
