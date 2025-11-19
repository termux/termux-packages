TERMUX_PKG_HOMEPAGE=https://dwm.suckless.org/
TERMUX_PKG_DESCRIPTION="A dynamic window manager for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6"
TERMUX_PKG_SRCURL="https://dl.suckless.org/dwm/dwm-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7cfc2c6d9386c07c49e2c906f209c18ba3364ce0b4872eae39f56efdb7fc00a3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dmenu, fontconfig, libx11, libxft, libxinerama, st"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cp config.def.h config.h
}
