TERMUX_PKG_HOMEPAGE=https://memcached.org/
TERMUX_PKG_DESCRIPTION="Free & open source, high-performance, distributed memory object caching system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.5.14
TERMUX_PKG_SHA256=9c5bdf29a780fb6c6f7c9eaaeeda0583efdf663193758c3e316c969a510af2a9
TERMUX_PKG_SRCURL=https://www.memcached.org/files/memcached-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libevent, libsasl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-sasl --disable-coverage"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    export ac_cv_c_endian=little

    # fix SASL configuration path
    perl -p -i -e "s#/etc/sasl#$TERMUX_PREFIX/etc/sasl#" $TERMUX_PKG_BUILDDIR/sasl_defs.c

    # getsubopt() taken from https://github.com/lxc/lxc/blob/master/src/include/getsubopt.c
    cp $TERMUX_PKG_BUILDER_DIR/getsubopt.c $TERMUX_PKG_SRCDIR
    cp $TERMUX_PKG_BUILDER_DIR/getsubopt.h $TERMUX_PKG_SRCDIR
}
