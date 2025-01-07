TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/suil.html
TERMUX_PKG_DESCRIPTION="A library for loading and wrapping LV2 plugin UIs"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.20"
TERMUX_PKG_SRCURL=https://download.drobilla.net/suil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=334a3ed3e73d5e17ff400b3db9801f63809155b0faa8b1b9046f9dd3ffef934e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="lv2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk2=disabled
-Dgtk3=disabled
-Dqt5=disabled
-Dx11=disabled
-Ddocs=disabled
"
