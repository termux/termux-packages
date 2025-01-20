TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/suil.html
TERMUX_PKG_DESCRIPTION="A library for loading and wrapping LV2 plugin UIs"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.22"
TERMUX_PKG_SRCURL=https://download.drobilla.net/suil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d720969e0f44a99d5fba35c733a43ed63a16b0dab867970777efca4b25387eb7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="lv2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk2=disabled
-Dgtk3=disabled
-Dqt5=disabled
-Dx11=disabled
-Ddocs=disabled
"
