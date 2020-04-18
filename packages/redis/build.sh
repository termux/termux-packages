TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=5.0.9
TERMUX_PKG_SRCURL=http://download.redis.io/releases/redis-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=53d0ae164cd33536c3d4b720ae9a128ea6166ebf04ff1add3b85f1242090cb85
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/redis.conf"

termux_step_pre_configure() {
	export PREFIX=$TERMUX_PREFIX
	export USE_JEMALLOC=no

	if [ $TERMUX_ARCH = "i686" ]; then
		sed -i 's/FINAL_LIBS=-lm/FINAL_LIBS=-lm -latomic/' $TERMUX_PKG_SRCDIR/src/Makefile
	fi
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/redis.conf $TERMUX_PREFIX/etc/redis.conf
}
