TERMUX_PKG_HOMEPAGE=https://jcorporation.github.io/myMPD/
TERMUX_PKG_DESCRIPTION="A standalone and lightweight web-based MPD client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=10.2.1
TERMUX_PKG_SRCURL=https://github.com/jcorporation/myMPD/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=617a67720c0322b0c08c9a29df45f58762e2b62d689b37d92a97fefb5a57aaab
TERMUX_PKG_DEPENDS="libflac, libid3tag, openssl, pcre2, resolv-conf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DMATH_LIB=m
"
TERMUX_CMAKE_BUILD="Unix Makefiles"
