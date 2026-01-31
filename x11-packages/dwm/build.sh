TERMUX_PKG_HOMEPAGE=https://dwm.suckless.org/
TERMUX_PKG_DESCRIPTION="A dynamic window manager for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8"
TERMUX_PKG_SRCURL="https://dl.suckless.org/dwm/dwm-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=bcf540589ad174d4073f4efa658828411e2f5ba63196cfaf6b71363700f590b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dmenu, fontconfig, libx11, libxft, libxinerama, st"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cp config.def.h config.h
}
