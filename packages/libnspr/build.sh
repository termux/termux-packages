TERMUX_PKG_HOMEPAGE=https://hg.mozilla.org/projects/nspr
TERMUX_PKG_DESCRIPTION="Netscape Portable Runtime (NSPR)"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.33
TERMUX_PKG_SRCURL=https://archive.mozilla.org/pub/nspr/releases/v${TERMUX_PKG_VERSION}/src/nspr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b23ee315be0e50c2fb1aa374d17f2d2d9146a835b1a79c1918ea15d075a693d7
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
