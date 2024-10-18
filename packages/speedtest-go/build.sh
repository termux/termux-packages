TERMUX_PKG_HOMEPAGE=https://github.com/showwin/speedtest-go/
TERMUX_PKG_DESCRIPTION="Command line interface to test internet speed using speedtest.net"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.9"
TERMUX_PKG_SRCURL=https://github.com/showwin/speedtest-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1273ad19dc8ecc4ff40204c62c372bb90c81c73c1cf3a9b208bab7f1035dfa67
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin speedtest-go
}
