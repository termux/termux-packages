TERMUX_PKG_HOMEPAGE=https://github.com/pufferffish/wireproxy
TERMUX_PKG_DESCRIPTION="Wireguard client that exposes itself as a socks5 proxy"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/pufferffish/wireproxy/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3e08e79e3c1b66b7e129426dc6e84b93a1fb3827edde96d85bbf863a5a66c8ff
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
