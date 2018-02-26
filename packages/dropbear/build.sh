TERMUX_PKG_HOMEPAGE=https://matt.ucc.asn.au/dropbear/dropbear.html
TERMUX_PKG_DESCRIPTION="Small SSH server and client"
TERMUX_PKG_DEPENDS="libutil, termux-auth"
TERMUX_PKG_VERSION=2017.75
TERMUX_PKG_REVISION=2
#Use the official git mirror
TERMUX_PKG_SRCURL=https://github.com/mkj/dropbear/archive/DROPBEAR_${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SRCURL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9e73e9a8d0671ceea83ad12e16eb13d4e54a165b1c2e9463d5b2e54b6fd28111
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog --disable-utmp --disable-utmpx --disable-wtmp"
# Avoid linking to libcrypt for server password authentication:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="MULTI=1"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	cd $TERMUX_PKG_SRCDIR
	autoreconf -if
	LDFLAGS+=" -ltermux-auth"
}

termux_step_create_debscripts () {
        echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p $TERMUX_PREFIX/etc/dropbear" >> postinst
        echo "for a in rsa dss ecdsa; do" >> postinst
        echo "    KEYFILE=$TERMUX_PREFIX/etc/dropbear/dropbear_\${a}_host_key" >> postinst
        echo "    test ! -f \$KEYFILE && dropbearkey -t \$a -f \$KEYFILE" >> postinst
        echo "done" >> postinst
        echo "exit 0" >> postinst
        chmod 0755 postinst
}
