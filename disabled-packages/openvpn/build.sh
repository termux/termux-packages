TERMUX_PKG_HOMEPAGE=https://openvpn.net
TERMUX_PKG_DESCRIPTION='An easy-to-use, robust, and highly configurable VPN (Virtual Private Network)'
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_DEPENDS="openssl, liblzo"
TERMUX_PKG_SRCURL=https://swupdate.openvpn.net/community/releases/openvpn-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6f23ba49a1dbeb658f49c7ae17d9ea979de6d92c7357de3d55cd4525e1b2f87e
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=' --disable-plugin-auth-pam --disable-systemd --disable-debug'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=' --enable-iproute2 --enable-small --enable-x509-alt-username'
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'

termux_step_pre_configure () {
    # we modify configure.ac
    # uncomment if you want to apply configure.patch
    # autoreconf -i $TERMUX_PKG_SRCDIR

    export ac_cv_func_getpwnam='yes'
    # need to provide getpass, else you "can't get console input"
    export ac_cv_func_getpass='yes'
    cp "$TERMUX_PKG_BUILDER_DIR/netbsd_getpass.c" "$TERMUX_PKG_SRCDIR/src/openvpn/"

    # paths to external programs used by openvpn
    export IFCONFIG="$TERMUX_PREFIX/bin/applets/ifconfig"
    export ROUTE="$TERMUX_PREFIX/bin/applets/route"
    export IPROUTE="$TERMUX_PREFIX/bin/ip"
    export NETSTAT="$TERMUX_PREFIX/bin/applets/netstat"

#    CFLAGS="$CFLAGS -DTARGET_ANDROID"
    LDFLAGS="$LDFLAGS -llog "
}

termux_step_post_make_install () {
    # helper script
    install -m700 "${TERMUX_PKG_BUILDER_DIR}"/termux-openvpn "${TERMUX_PREFIX}"/bin/
    # Install examples
    install -d -m755 "${TERMUX_PREFIX}"/share/openvpn/examples
    cp "${TERMUX_PKG_SRCDIR}"/sample/sample-config-files/* "${TERMUX_PREFIX}"/share/openvpn/examples
}
