TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.0"
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v$TERMUX_PKG_VERSION/libqalculate-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=07b11dba19a80e8c5413a6bb25c81fb30cc0935b54fa0c9090c4ff8661985e08
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcurl, libgmp, libiconv, libmpfr, libxml2, readline"
TERMUX_PKG_BREAKS="qalc-dev"
TERMUX_PKG_REPLACES="qalc-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
