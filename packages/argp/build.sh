TERMUX_PKG_HOMEPAGE=https://github.com/argp-standalone/argp-standalone
TERMUX_PKG_DESCRIPTION="Standalone version of arguments parsing functions from GLIBC"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.0
TERMUX_PKG_SRCURL=https://github.com/argp-standalone/argp-standalone/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c29eae929dfebd575c38174f2c8c315766092cec99a8f987569d0cad3c6d64f6

termux_step_pre_configure() {
	autoreconf -fi
}

termux_step_post_make_install() {
	install -Dm600 $TERMUX_PKG_SRCDIR/argp.h $TERMUX_PREFIX/include
}
