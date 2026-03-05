TERMUX_PKG_HOMEPAGE=https://github.com/pufferffish/wireproxy
TERMUX_PKG_DESCRIPTION="Wireguard client that exposes itself as a socks5 proxy"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.2"
TERMUX_PKG_SRCURL=https://github.com/pufferffish/wireproxy/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c2568017c7e27c0642c27b68b9b1adb34e6fe8165277f75a48e47d6af6bcf3e4
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_make() {
	termux_setup_golang

	go build -trimpath -ldflags "-s -w -X 'main.version=${TERMUX_PKG_VERSION}'" ./cmd/wireproxy
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX"/bin wireproxy
}
