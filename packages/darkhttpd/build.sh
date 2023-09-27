TERMUX_PKG_HOMEPAGE=https://unix4lyfe.org/darkhttpd
TERMUX_PKG_DESCRIPTION="A simple webserver, implemented in a single .c file."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="David Paskevic @casept"
TERMUX_PKG_VERSION="1.14"
TERMUX_PKG_SRCURL=https://github.com/emikulic/darkhttpd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e063de9efa5635260c8def00a4d41ec6145226a492d53fa1dac436967670d195
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $LDFLAGS"
}
