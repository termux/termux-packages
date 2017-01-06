TERMUX_PKG_HOMEPAGE=http://patches.freeiz.com
TERMUX_PKG_DESCRIPTION="Fast, easy to use email client"
TERMUX_PKG_VERSION=2.20
TERMUX_PKG_SRCURL=http://patches.freeiz.com/alpine/release/src/alpine-${TERMUX_PKG_VERSION}.tar.xz
#TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="  --with-c-client-target=lnx --without-pthread --without-password-prog --without-tcl --without-ldap --without-krb5 --disable-debug --with-system-pinerc=/data/data/com.termux/files/usr/etc/pine.conf --with-password-prog=no"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	LDFLAGS+=" -lcrypt -llog"
	cp $TERMUX_PKG_BUILDER_DIR/getpass.c $TERMUX_PKG_SRCDIR/include/
	cp $TERMUX_PKG_BUILDER_DIR/getpass.h $TERMUX_PKG_SRCDIR/include/
	cd $TERMUX_PKG_SRCDIR
	autoreconf -if
	touch $TERMUX_PKG_SRCDIR/imap/lnxok
	export TPATH=$PATH
}

termux_step_post_configure() {
	cd pith
	$CC_FOR_BUILD help_c_gen.c -o help_c_gen
	$CC_FOR_BUILD help_h_gen.c -o help_h_gen
}
