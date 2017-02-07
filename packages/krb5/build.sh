TERMUX_PKG_HOMEPAGE='https://web.mit.edu/kerberos'
TERMUX_PKG_DESCRIPTION='The Kerberos network authentication system'
TERMUX_PKG_VERSION='1.15'
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, readline, c-ares, openssl, libutil"
TERMUX_PKG_SRCURL="https://web.mit.edu/kerberos/dist/krb5/$TERMUX_PKG_VERSION/krb5-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256='fd34752774c808ab4f6f864f935c49945f5a56b62240b1ad4ab1af7b4ded127c'
TERMUX_PKG_FOLDERNAME="krb5-$TERMUX_PKG_VERSION/src"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=' --with-readline --with-netlib=-lcares --without-system-verto'

termux_step_pre_configure () {
    # cannot test these when cross compiling
    export krb5_cv_attr_constructor_destructor='yes,yes'
    export ac_cv_func_regcomp='yes'
    export ac_cv_printf_positional='yes'

    # disable some -Werror=
    export krb5_cv_cc_flag__dash_Werror_eq_uninitialized='no'
    export krb5_cv_cc_flag__dash_Werror_dash_implicit_dash_function_dash_declaration='no'

    # bionic doesn't have getpass
    cp "$TERMUX_PKG_BUILDER_DIR/netbsd_getpass.c" "$TERMUX_PKG_SRCDIR/clients/kpasswd/"

    LDFLAGS="$LDFLAGS -landroid-glob -llog"
}
