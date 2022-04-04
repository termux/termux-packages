TERMUX_PKG_HOMEPAGE=https://qalculate.github.io/
TERMUX_PKG_DESCRIPTION="Powerful and easy to use command line calculator"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.1.1"
TERMUX_PKG_SRCURL=https://github.com/Qalculate/libqalculate/releases/download/v$TERMUX_PKG_VERSION/libqalculate-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b5611a91293be40fbe8723a81937e25ffb54e6ad6e60f282d044ed92f2d97002
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libiconv, libcurl, libmpfr, libxml2, readline, libgmp, zlib"
TERMUX_PKG_BREAKS="qalc-dev"
TERMUX_PKG_REPLACES="qalc-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-icu"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
