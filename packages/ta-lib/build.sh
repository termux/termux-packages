TERMUX_PKG_HOMEPAGE=https://ta-lib.org/
TERMUX_PKG_DESCRIPTION="Technical analysis library with indicators like ADX"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://github.com/TA-Lib/ta-lib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=43e3761cf6bc4a5ab6c675268a09a72ea074643c6e06defe5e4b4e51eae1ea50
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BREAKS="talib"
TERMUX_PKG_REPLACES="talib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	autoreconf -fi
}
