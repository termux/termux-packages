TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/suil.html
TERMUX_PKG_DESCRIPTION="A library for loading and wrapping LV2 plugin UIs"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.24"
TERMUX_PKG_SRCURL=https://download.drobilla.net/suil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0d15d407c8b1010484626cb63b3317ba0a012edf3308b66b0f7aa389bd99603b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="lv2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk2=disabled
-Dgtk3=disabled
-Dqt5=disabled
-Dx11=disabled
-Ddocs=disabled
"
