TERMUX_PKG_HOMEPAGE=https://cointop.sh/
TERMUX_PKG_DESCRIPTION="A fast and lightweight interactive terminal based UI application for tracking cryptocurrencies"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.10
TERMUX_PKG_SRCURL=https://github.com/cointop-sh/cointop/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18da0d25288deec7156ddd1d6923960968ab4adcdc917f85726b97d555d9b1b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="build VERSION=${TERMUX_PKG_VERSION#*:}"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/cointop
}
