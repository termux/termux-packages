TERMUX_PKG_HOMEPAGE=https://unix4lyfe.org/darkhttpd
TERMUX_PKG_DESCRIPTION="A simple webserver, implemented in a single .c file."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/emikulic/darkhttpd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4fee9927e2d8bb0a302f0dd62f9ff1e075748fa9f5162c9481a7a58b41462b56
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $LDFLAGS"
}
