TERMUX_PKG_HOMEPAGE=https://miniupnp.tuxfamily.org/libnatpmp.html
TERMUX_PKG_DESCRIPTION="Portable and fully compliant implementation of NAT-PMP"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=20230423
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://miniupnp.tuxfamily.org/files/libnatpmp-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0684ed2c8406437e7519a1bd20ea83780db871b3a3a5d752311ba3e889dbfc70
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="INSTALLPREFIX=$TERMUX_PREFIX"

termux_step_post_get_source() {
	mv setup.py{,.unused}
}

termux_step_configure() {
	:
}
