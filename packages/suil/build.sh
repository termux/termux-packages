TERMUX_PKG_HOMEPAGE=https://drobilla.net/software/suil.html
TERMUX_PKG_DESCRIPTION="A library for loading and wrapping LV2 plugin UIs"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.26"
TERMUX_PKG_SRCURL=https://download.drobilla.net/suil-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=62808916602c47d201a1ec2d246323a8048243f2bf972f859f0db1db4662ee43
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="lv2"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk2=disabled
-Dgtk3=disabled
-Dqt5=disabled
-Dx11=disabled
-Ddocs=disabled
"
