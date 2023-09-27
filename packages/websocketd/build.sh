TERMUX_PKG_HOMEPAGE=http://websocketd.com/
TERMUX_PKG_DESCRIPTION="Turn any program that uses STDIN/STDOUT into a WebSocket server"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/joewalnes/websocketd/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b8fe0fad586d794e002340ee597059b2cfc734ba7579933263aef4743138fe5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy 
}

termux_step_make() {
	go build -o websocketd -ldflags "-X main.version=${TERMUX_PKG_VERSION} -X main.buildinfo=$(date +%s)-@termux-${GOARCH}"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}"/bin websocketd
}
