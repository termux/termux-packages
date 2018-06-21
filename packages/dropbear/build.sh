TERMUX_PKG_HOMEPAGE=https://matt.ucc.asn.au/dropbear/dropbear.html
TERMUX_PKG_DESCRIPTION="Small SSH server and client"
TERMUX_PKG_DEPENDS="libutil, readline"
TERMUX_PKG_CONFLICTS="openssh"
TERMUX_PKG_VERSION=2018.76
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f2fb9167eca8cf93456a5fc1d4faf709902a3ab70dd44e352f3acbc3ffdaea65
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog --disable-utmp --disable-utmpx --disable-wtmp"
TERMUX_PKG_BUILD_IN_SRC="yes"
# Avoid linking to libcrypt for server password authentication:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
# use own implementation of getpass
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_getpass=yes LIBS=-lreadline"
# build a multi-call binary
TERMUX_PKG_EXTRA_MAKE_ARGS="MULTI=1"

termux_step_post_make_install() {
    ln -sf "dropbearmulti" "${TERMUX_PREFIX}/bin/ssh"
}

termux_step_create_debscripts () {
    {
        echo "#!$TERMUX_PREFIX/bin/sh"
        echo "mkdir -p $TERMUX_PREFIX/etc/dropbear"
        echo "for a in rsa dss ecdsa; do"
        echo "    KEYFILE=$TERMUX_PREFIX/etc/dropbear/dropbear_\${a}_host_key"
        echo "    test ! -f \$KEYFILE && dropbearkey -t \$a -f \$KEYFILE"
        echo "done"
        echo "exit 0"
    } > postinst
    chmod 0755 postinst
}
