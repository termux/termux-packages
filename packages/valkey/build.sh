TERMUX_PKG_HOMEPAGE=https://valkey.io/
TERMUX_PKG_DESCRIPTION="In-memory data structure store used as a database, cache and message broker"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.1.4"
TERMUX_PKG_SRCURL="https://github.com/valkey-io/valkey/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fe3d623600a1c046b4668feec097c507b4ae52f20c1fc7f1ebd384c07a165e77
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libandroid-glob"
TERMUX_PKG_CONFFILES="etc/valkey.conf"
TERMUX_PKG_BREAKS="redis"
TERMUX_PKG_CONFLICTS="redis"
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
