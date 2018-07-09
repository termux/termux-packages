TERMUX_PKG_HOMEPAGE=https://memcached.org/
TERMUX_PKG_DESCRIPTION="Free & open source, high-performance, distributed memory object caching system"
TERMUX_PKG_VERSION=1.5.9
TERMUX_PKG_SHA256=4af3577dbf71cb0a748096dc6562ccd587cddb7565c720f1fdb23e8a34241d06
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
