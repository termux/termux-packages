TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/ta-lib/
TERMUX_PKG_DESCRIPTION="Technical analysis library with indicators like ADX."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/ta-lib/ta-lib-$TERMUX_PKG_VERSION-src.tar.gz
TERMUX_PKG_SHA256=9ff41efcb1c011a4b4b6dfc91610b06e39b1d7973ed5d4dee55029a0ac4dc651
TERMUX_PKG_BREAKS="talib"
TERMUX_PKG_REPLACES="talib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	curl https://sourceforge.net/p/ta-lib/code/HEAD/tree/tags/release-${TERMUX_PKG_VERSION//./-}/ta-lib/LICENSE.TXT?format=raw -o $TERMUX_PKG_SRCDIR/LICENSE
}
