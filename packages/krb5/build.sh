TERMUX_PKG_HOMEPAGE=https://web.mit.edu/kerberos
TERMUX_PKG_DESCRIPTION="The Kerberos network authentication system"
TERMUX_PKG_VERSION=1.15.1
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, readline, c-ares, openssl, libutil"
TERMUX_PKG_SRCURL="https://web.mit.edu/kerberos/dist/krb5/1.15/krb5-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=437c8831ddd5fde2a993fef425dedb48468109bb3d3261ef838295045a89eb45
TERMUX_PKG_FOLDERNAME="krb5-$TERMUX_PKG_VERSION/src"
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-readline --with-netlib=-lcares --without-system-verto"

termux_step_pre_configure () {
    # cannot test these when cross compiling
    export krb5_cv_attr_constructor_destructor='yes,yes'
    export ac_cv_func_regcomp='yes'
    export ac_cv_printf_positional='yes'

    # bionic doesn't have getpass
    cp "$TERMUX_PKG_BUILDER_DIR/netbsd_getpass.c" "$TERMUX_PKG_SRCDIR/clients/kpasswd/"

    LDFLAGS="$LDFLAGS -landroid-glob -llog"
}
