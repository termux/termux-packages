TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=5.0.5
TERMUX_PKG_SRCURL=http://download.redis.io/releases/redis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2139009799d21d8ff94fc40b7f36ac46699b9e1254086299f8d3b223ca54a375
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/redis.conf"

termux_step_pre_configure() {
	export PREFIX=$TERMUX_PREFIX
	export USE_JEMALLOC=no

	LDFLAGS+=" -llog"

	if [ $TERMUX_ARCH = "i686" ]; then
		sed -i 's/FINAL_LIBS=-lm/FINAL_LIBS=-lm -latomic/' $TERMUX_PKG_SRCDIR/src/Makefile
	fi
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/redis.conf $TERMUX_PREFIX/etc/redis.conf
}
