TERMUX_PKG_HOMEPAGE=https://unix4lyfe.org/darkhttpd
TERMUX_PKG_DESCRIPTION="A simple webserver, implemented in a single .c file."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.16"
TERMUX_PKG_SRCURL=https://github.com/emikulic/darkhttpd/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ab97ea3404654af765f78282aa09cfe4226cb007d2fcc59fe1a475ba0fef1981
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $LDFLAGS"
}
