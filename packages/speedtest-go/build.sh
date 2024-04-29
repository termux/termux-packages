TERMUX_PKG_HOMEPAGE=https://github.com/showwin/speedtest-go/
TERMUX_PKG_DESCRIPTION="Command line interface to test internet speed using speedtest.net"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.12"
TERMUX_PKG_SRCURL=https://github.com/showwin/speedtest-go/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1e71f49f4cc0c0aea73eaa8264eedcb9f1ca5788182a4b6c343186d2ac59e093
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
