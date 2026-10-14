TERMUX_PKG_HOMEPAGE=https://ta-lib.org/
TERMUX_PKG_DESCRIPTION="Technical analysis library with indicators like ADX"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.1
TERMUX_PKG_SRCURL=https://github.com/TA-Lib/ta-lib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b30f58c24587f5ac46abe7caded1b49c3e1639ca177f4f51079d4fe051a5fae1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BREAKS="talib"
TERMUX_PKG_REPLACES="talib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	autoreconf -fi
}
