TERMUX_PKG_HOMEPAGE=https://hg.mozilla.org/projects/nspr
TERMUX_PKG_DESCRIPTION="Netscape Portable Runtime (NSPR)"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.35
TERMUX_PKG_SRCURL=https://archive.mozilla.org/pub/nspr/releases/v${TERMUX_PKG_VERSION}/src/nspr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ea3297ea5969b5d25a5dd8d47f2443cda88e9ee746301f6e1e1426f8a6abc8f
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	TERMUX_PKG_SRCDIR+="/nspr"
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DANDROID"
	LDFLAGS+=" -llog"

	if [ $TERMUX_ARCH_BITS -eq 64 ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-64bit"
	fi

	TERMUX_PKG_EXTRA_MAKE_ARGS+="
		NSINSTALL=$TERMUX_PKG_HOSTBUILD_DIR/config/nsinstall
		NOW=$TERMUX_PKG_HOSTBUILD_DIR/config/now
		"
}
