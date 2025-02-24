TERMUX_PKG_HOMEPAGE=https://www.storj.io/integrations/uplink-cli
TERMUX_PKG_DESCRIPTION="Storj DCS Uplink CLI"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.122.1"
TERMUX_PKG_SRCURL=https://github.com/storj/storj/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fc5a5f9f078f4ff619d06ed0cad8c6b8b84086297c265b354467929be3f06b97
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
