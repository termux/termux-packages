TERMUX_PKG_HOMEPAGE=https://github.com/showwin/speedtest-go/
TERMUX_PKG_DESCRIPTION="Command line interface to test internet speed using speedtest.net"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.10"
TERMUX_PKG_SRCURL=https://github.com/showwin/speedtest-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=70a2937d0759820fe7ee8f61b960d60c07b34c0d783ed11c0065b68fe2964aea
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
