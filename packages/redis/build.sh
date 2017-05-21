TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker"
TERMUX_PKG_VERSION=3.2.9
TERMUX_PKG_SRCURL=http://download.redis.io/releases/redis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=6eaacfa983b287e440d0839ead20c2231749d5d6b78bbe0e0ffa3a890c59ff26
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_CONFFILES="etc/redis.conf"

termux_step_pre_configure() {
    export PREFIX=$TERMUX_PREFIX
    export USE_JEMALLOC=no

    LDFLAGS+=" -llog"
}

termux_step_post_make_install() {
    cp $TERMUX_PKG_SRCDIR/redis.conf $TERMUX_PREFIX/etc/redis.conf
}
