TERMUX_PKG_HOMEPAGE=https://matt.ucc.asn.au/dropbear/dropbear.html
TERMUX_PKG_DESCRIPTION="Small SSH server and client"
TERMUX_PKG_DEPENDS="libutil"
TERMUX_PKG_VERSION=2016.73
# Both main site and mirror is sporadically down, switching to fedora site:
# TERMUX_PKG_SRCURL=https://matt.ucc.asn.au/dropbear/releases/dropbear-${TERMUX_PKG_VERSION}.tar.bz2
# TERMUX_PKG_SRCURL=https://dropbear.nl/mirror/dropbear-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SRCURL=http://pkgs.fedoraproject.org/lookaside/pkgs/dropbear/dropbear-2015.71.tar.bz2/md5/2ccc0a2f3e37ca221db12c5af6a88137/dropbear-2015.71.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog --disable-utmp --disable-utmpx --disable-wtmp"
# Avoid linking to libcrypt for server password authentication:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_lib_crypt_crypt=no"
TERMUX_PKG_EXTRA_MAKE_ARGS="MULTI=1"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_create_debscripts () {
        echo "mkdir -p $TERMUX_PREFIX/etc/dropbear" >> postinst
        echo "for a in rsa dss ecdsa; do" >> postinst
        echo "    KEYFILE=$TERMUX_PREFIX/etc/dropbear/dropbear_\${a}_host_key" >> postinst
        echo "    test ! -f \$KEYFILE && dropbearkey -t \$a -f \$KEYFILE" >> postinst
        echo "done" >> postinst
        echo "exit 0" >> postinst
        chmod 0755 postinst
}
