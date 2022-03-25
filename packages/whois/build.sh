TERMUX_PKG_HOMEPAGE=https://github.com/rfc1036/whois
TERMUX_PKG_DESCRIPTION="An intelligent Whois client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.5.12
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/w/whois/whois_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f1c5bab781b7f2357dab1039e8875d41ff7b5d03a78c27443fa26351952a0822
TERMUX_PKG_DEPENDS="libcrypt, libiconv, libidn2"
TERMUX_PKG_CONFLICTS="inetutils (<< 1.9.4-13)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
prefix=$TERMUX_PREFIX
HAVE_ICONV=1
"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
