TERMUX_PKG_HOMEPAGE=https://www.storj.io/integrations/uplink-cli
TERMUX_PKG_DESCRIPTION="Storj DCS Uplink CLI"
TERMUX_PKG_LICENSE="AGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.164.1"
TERMUX_PKG_SRCURL="https://github.com/storj/storj/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0bc1203476965b8aa8500e1faa474759480d6cd24a4b3fdbdd7aa6b377c05d0a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build ./cmd/uplink
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" uplink
}
