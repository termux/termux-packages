TERMUX_PKG_HOMEPAGE=https://redis.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:8.2.2"
TERMUX_PKG_SRCURL=https://download.redis.io/releases/redis-${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=4e340e8e822a82114b6fb0f7ca581b749fa876e31e36e9fbcb75416bec9d0608
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_CONFFILES="etc/redis.conf"
TERMUX_PKG_BREAKS="valkey"
TERMUX_PKG_CONFLICTS="valkey"
TERMUX_PKG_REPLACES="valkey"

termux_step_pre_configure() {
	export PREFIX=$TERMUX_PREFIX
	export USE_JEMALLOC=no

	CPPFLAGS+=" -DHAVE_BACKTRACE"
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-execinfo -landroid-glob"
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/redis.conf $TERMUX_PREFIX/etc/redis.conf
}
