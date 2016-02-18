TERMUX_PKG_HOMEPAGE=https://www.isc.org/downloads/bind/
TERMUX_PKG_DESCRIPTION="Clients provided with BIND"
# NOTE: When changing this version, you also needo to change TERMUX_PKG_SRCURL
# and TERMUX_PKG_FOLDERNAME.
TERMUX_PKG_VERSION=9.10.3.3
# TERMUX_PKG_SRCURL="https://www.isc.org/downloads/file/bind-9-10-3-p2/?version=tar-gz"
TERMUX_PKG_SRCURL="https://ftp.isc.org/isc/bind/cur/9.10/bind-9.10.3-P3.tar.gz"
TERMUX_PKG_FOLDERNAME="bind-9.10.3-P3"
TERMUX_PKG_DEPENDS="openssl, readline, resolv-conf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-gssapi=no --with-randomdev=/dev/random -with-ecdsa=no --with-gost=no --with-libxml2=no --with-libtool"

export BUILD_AR=ar
export BUILD_CC=gcc
export BUILD_CFLAGS=
export BUILD_CPPFLAGS=
export BUILD_LDFLAGS=
export BUILD_RANLIB=

_RESOLV_CONF=$TERMUX_PREFIX/etc/resolv.conf
CFLAGS+=" $CPPFLAGS -DRESOLV_CONF=\\\"$_RESOLV_CONF\\\""
LDFLAGS+=" -llog"

termux_step_make () {
	make -C lib/isc
	make -C lib/dns
	make -C lib/isccc
	make -C lib/isccfg
	make -C lib/bind9
	make -C lib/lwres
	make -C bin/dig
}

termux_step_make_install () {
	make -C lib/isc install
	make -C lib/dns install
	make -C lib/isccc install
	make -C lib/isccfg install
	make -C lib/bind9 install
	make -C lib/lwres install
	make -C bin/dig install
}
