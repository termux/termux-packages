TERMUX_PKG_HOMEPAGE=https://github.com/rfc1036/whois
TERMUX_PKG_DESCRIPTION="An intelligent Whois client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.5.17
TERMUX_PKG_SRCURL=https://ftp.debian.org/debian/pool/main/w/whois/whois_${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=effe86e6d75101c2f33a0b3d2d948ab54aa57893fedc3b9983ffd55e881e2521
TERMUX_PKG_DEPENDS="libcrypt, libiconv, libidn2"
TERMUX_PKG_CONFLICTS="inetutils (<< 1.9.4-13)"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
prefix=$TERMUX_PREFIX
HAVE_ICONV=1
"

TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DHAVE_CRYPT_H"
	LDFLAGS+=" -liconv"
}
