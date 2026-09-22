TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:8.10.0"
TERMUX_PKG_SRCURL="https://download.redis.io/releases/redis-${TERMUX_PKG_VERSION:2}.tar.gz"
TERMUX_PKG_SHA256=f1baa4b28befd417aa6577ebeedde9e9fc7814cfcc299b2a6d2fd99ef7420a6c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/redis.conf"
TERMUX_PKG_BREAKS="valkey"
TERMUX_PKG_CONFLICTS="valkey"

termux_step_pre_configure() {
	export PREFIX="$TERMUX_PREFIX"
	export USE_JEMALLOC=no

	CPPFLAGS+=" -DHAVE_BACKTRACE"
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-execinfo -landroid-glob"
}

termux_step_make() {
	make -C src -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	make -C src -j 1 install
}

termux_step_post_make_install() {
	install -Dm600 "$TERMUX_PKG_SRCDIR/redis.conf" "$TERMUX_PREFIX/etc/redis.conf"
}
