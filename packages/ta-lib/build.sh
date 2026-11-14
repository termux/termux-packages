TERMUX_PKG_HOMEPAGE=https://ta-lib.org/
TERMUX_PKG_DESCRIPTION="Technical analysis library with indicators like ADX"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.3
TERMUX_PKG_SRCURL=https://github.com/TA-Lib/ta-lib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e5289e3f7f651988e8cc9d0ee3ebac44951c56ff203cd49fbf54f70999e9e569
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BREAKS="talib"
TERMUX_PKG_REPLACES="talib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
	autoreconf -fi
}
