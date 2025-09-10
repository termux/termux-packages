TERMUX_PKG_HOMEPAGE=https://www.xiph.org/oggz/
TERMUX_PKG_DESCRIPTION="Command and library to inspect, tweak, edit and validate Ogg files"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.xiph.org/releases/liboggz/liboggz-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2466d03b67ef0bcba0e10fb352d1a9ffd9f96911657abce3cbb6ba429c656e2f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libogg"
TERMUX_PKG_BREAKS="liboggz-dev"
TERMUX_PKG_REPLACES="liboggz-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
"
