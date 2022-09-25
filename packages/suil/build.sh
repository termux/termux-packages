TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/suil.html
TERMUX_PKG_DESCRIPTION="A library for loading and wrapping LV2 plugin UIs"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.18
TERMUX_PKG_SRCURL=https://download.drobilla.net/suil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=84ada094fbe17ad3e765379002f3a0c7149b43b020235e4d7fa41432f206f85f
TERMUX_PKG_DEPENDS="lv2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk2=disabled
-Dgtk3=disabled
-Dqt5=disabled
-Dx11=disabled
"
