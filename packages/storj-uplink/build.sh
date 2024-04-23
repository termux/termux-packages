TERMUX_PKG_HOMEPAGE=https://www.storj.io/integrations/uplink-cli
TERMUX_PKG_DESCRIPTION="Storj DCS Uplink CLI"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.101.3"
TERMUX_PKG_SRCURL=https://github.com/storj/storj/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6cfed36a133b323ef852277fe2de5e3fc5d0ae660471c36ef38773732a1937f6
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
	install -Dm700 -t $TERMUX_PREFIX/bin uplink
}
