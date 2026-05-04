TERMUX_PKG_HOMEPAGE=https://valkey.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.0.3"
TERMUX_PKG_SRCURL="https://github.com/valkey-io/valkey/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e220f4b0143292ee6ea6d705aa40d45a0c8a77759b3e94c201cb5c25dbdca42f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob"
TERMUX_PKG_CONFFILES="etc/valkey.conf"
TERMUX_PKG_BREAKS="redis"
TERMUX_PKG_CONFLICTS="redis"
TERMUX_PKG_REPLACES="redis"
TERMUX_PKG_PROVIDES="redis"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
-DBUILD_MALLOC=libc
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DHAVE_BACKTRACE"
	CFLAGS+=" $CPPFLAGS"
	LDFLAGS+=" -landroid-execinfo -landroid-glob"

	( cd "$TERMUX_PKG_SRCDIR/src" && ./mkreleasehdr.sh )
}

termux_step_post_make_install() {
	install -Dm600 "$TERMUX_PKG_SRCDIR/valkey.conf" "$TERMUX_PREFIX/etc/valkey.conf"
}
