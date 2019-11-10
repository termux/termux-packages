TERMUX_PKG_HOMEPAGE=https://unix4lyfe.org/darkhttpd
TERMUX_PKG_DESCRIPTION="A simple webserver, implemented in a single .c file."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.12
TERMUX_PKG_REVISION=1
TERMUX_PKG_MAINTAINER="David Paskevic @casept"
TERMUX_PKG_SRCURL=https://fossies.org/linux/www/darkhttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2652bc7e3dab35fcb64453616771016017a135e4b263ef73a36d29662593d472
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $LDFLAGS"
}
