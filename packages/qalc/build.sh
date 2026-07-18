TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.12.0"
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v$TERMUX_PKG_VERSION/libqalculate-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f3dfdcf97d5a9e3a5bc0ebe66afd184721b606276eee3ba0ada8c92a5e71d44c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcurl, libgmp, libiconv, libmpfr, libxml2, readline"
TERMUX_PKG_BREAKS="qalc-dev"
TERMUX_PKG_REPLACES="qalc-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"

termux_step_pre_configure() {
	# TODO: remove after ndk update, workaround for -std=gnu23
	autoreconf -fiv

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
