TERMUX_PKG_HOMEPAGE=https://www.isc.org/downloads/bind/
TERMUX_PKG_DESCRIPTION="Clients provided with BIND"
TERMUX_PKG_VERSION=9.10.3
TERMUX_PKG_SRCURL="https://www.isc.org/downloads/file/bind-9-10-3/?version=tar-gz"
TERMUX_PKG_FOLDERNAME="bind-${TERMUX_PKG_VERSION}"
#TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
#
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-gssapi=no --with-randomdev=/dev/random -with-ecdsa=yes --with-gost=yes --with-libxml2=no"
#TERMUX_MAKE_PROCESSES=1

export BUILD_AR=$AR
export BUILD_CC=$CC
export BUILD_CFLAGS="$CFLAGS"
export BUILD_CPPFLAGS="$CPPFLAGS"
export BUILD_LDFLAGS="$LDFLAGS"
export BUILD_RANLIB=$RANLIB

export AR=ar
export CC=gcc
export CFLAGS=
export CPPFLAGS=
export LDFLAGS=
export RANLIB=ranlib

termux_step_make () {
	make -C lib/dns &&
		make -C lib/isc &&
		make -C lib/bind9 &&
		make -C lib/isccfg &&
		make -C lib/lwres &&
		make -C bin/dig
}

termux_step_make_install () {
	make -C bin/dig install
}
