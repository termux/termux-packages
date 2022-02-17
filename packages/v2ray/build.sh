TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_SRCURL=https://github.com/v2fly/v2ray-core.git
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go mod init || :
	go mod tidy
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
