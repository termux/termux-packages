TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker"
TERMUX_PKG_VERSION=3.2.8
TERMUX_PKG_SRCURL=http://download.redis.io/releases/redis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=61b373c23d18e6cc752a69d5ab7f676c6216dc2853e46750a8c4ed791d68482c
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    export PREFIX=$TERMUX_PREFIX
    export USE_JEMALLOC=no

    LDFLAGS+=" -llog"
}