TERMUX_PKG_HOMEPAGE=http://patches.freeiz.com
TERMUX_PKG_DESCRIPTION="Fast, easy to use email client"
TERMUX_PKG_VERSION=2.20
TERMUX_PKG_SRCURL=http://patches.freeiz.com/alpine/release/src/alpine-${TERMUX_PKG_VERSION}.tar.xz
#TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-tcl --without-ldap --without-krb5 --disable-debug"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	cd $TERMUX_PKG_SRCDIR
	autoconf
}
