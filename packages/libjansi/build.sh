TERMUX_PKG_HOMEPAGE=https://fusesource.github.io/jansi/
TERMUX_PKG_DESCRIPTION="A small java library that allows you to use ANSI escape codes to format your console output"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/fusesource/jansi
TERMUX_PKG_GIT_BRANCH=jansi-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src/main/native PREFIX=$TERMUX_PREFIX"

termux_step_pre_configure() {
	cp $TERMUX_PKG_BUILDER_DIR/Makefile $TERMUX_PKG_SRCDIR/src/main/native/

	CFLAGS+=" -fPIC"
}
