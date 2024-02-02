TERMUX_PKG_HOMEPAGE=https://unix4lyfe.org/darkhttpd
TERMUX_PKG_DESCRIPTION="A simple webserver, implemented in a single .c file."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="David Paskevic @casept"
TERMUX_PKG_VERSION="1.15"
TERMUX_PKG_SRCURL=https://github.com/emikulic/darkhttpd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ea48cedafbf43186f4a8d1afc99b33b671adee99519658446022e6f63bd9eda9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $LDFLAGS"
}
