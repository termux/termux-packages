TERMUX_PKG_HOMEPAGE=https://memcached.org/
TERMUX_PKG_DESCRIPTION="Free & open source, high-performance, distributed memory object caching system"
TERMUX_PKG_VERSION=1.4.35
TERMUX_PKG_SRCURL=http://www.memcached.org/files/memcached-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f4815ac95aa06c0f360052a0a12010533b2b78c3bfe475b171606c1b61469476
TERMUX_PKG_DEPENDS="libevent, libsasl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-sasl --disable-coverage"

termux_step_pre_configure() {
    export ac_cv_c_endian=little

    CFLAGS+=" -D_XOPEN_SOURCE=500"
}