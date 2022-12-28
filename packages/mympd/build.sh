TERMUX_PKG_HOMEPAGE=https://jcorporation.github.io/myMPD/
TERMUX_PKG_DESCRIPTION="A standalone and lightweight web-based MPD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.1.7
TERMUX_PKG_SRCURL=https://github.com/jcorporation/myMPD/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=700b0e66ccdd00ba52e12654668114c44bb60d74ad51e3b904b8e071c4d853dd
TERMUX_PKG_DEPENDS="libflac, libid3tag, openssl, pcre2, resolv-conf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DMATH_LIB=m
"
TERMUX_CMAKE_BUILD="Unix Makefiles"
