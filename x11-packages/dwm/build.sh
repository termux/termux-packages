TERMUX_PKG_HOMEPAGE=https://dwm.suckless.org/
TERMUX_PKG_DESCRIPTION="A dynamic window manager for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7"
TERMUX_PKG_SRCURL="https://dl.suckless.org/dwm/dwm-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=91ffbaa148bf63e965b21eb94597edbba53431c19f5061874e04ef3c58c1f192
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dmenu, fontconfig, libx11, libxft, libxinerama, st"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	cp config.def.h config.h
}
