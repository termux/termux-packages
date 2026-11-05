TERMUX_PKG_HOMEPAGE=https://www.flamingspork.com/projects/libeatmydata/
TERMUX_PKG_DESCRIPTION='libeatmydata - because fsync() should be a no-op'
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <thunder-coding@termux.dev>"
TERMUX_PKG_VERSION="131"
TERMUX_PKG_SRCURL=https://github.com/stewartsmith/libeatmydata/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=70e496693fa43ec3a1fbe4750628b778d12a38c71138be6ab32bdc67c6d548ca
TERMUX_PKG_AUTO_UPDATE=true
# Needed for eatmydata script in $TERMUX_PREFIX/bin
TERMUX_PKG_DEPENDS="dash"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	autoreconf -fi
}
