TERMUX_PKG_HOMEPAGE=https://hg.mozilla.org/projects/nspr
TERMUX_PKG_DESCRIPTION="Netscape Portable Runtime (NSPR)"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.38"
TERMUX_PKG_SRCURL=https://archive.mozilla.org/pub/nspr/releases/v${TERMUX_PKG_VERSION}/src/nspr-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=72ee73ffcc6ef5e706965f855ecf470ec3986c3e188e12a8a8006e76f6b31a6f
TERMUX_PKG_AUTO_UPDATE=true
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
