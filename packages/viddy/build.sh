TERMUX_PKG_HOMEPAGE=https://github.com/sachaos/viddy
TERMUX_PKG_DESCRIPTION="A modern watch command"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.0"
TERMUX_PKG_SRCURL=https://github.com/sachaos/viddy/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b64cca44ef6367397498faae92296fc005156e6e5a7518b6f64ac2bc912044d0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	go mod init || :
	go mod tidy
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin viddy
}
