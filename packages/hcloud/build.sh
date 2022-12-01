TERMUX_PKG_HOMEPAGE=https://github.com/hetznercloud/cli
TERMUX_PKG_DESCRIPTION="Hetzner Cloud command line client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.31.0"
TERMUX_PKG_SRCURL=https://github.com/hetznercloud/cli/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f014e92e31e842c0aa49d82159a4e9df34d26bb896461b09680561216cb9246
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	# Below are taken from github.com/hetznercloud/cli@v1.30.1/.goreleaser.yml
	local CGO_ENABLED=0
	local LD_FLAGS="-s -w -X 'github.com/hetznercloud/cli/internal/version.Version=v${TERMUX_PKG_VERSION}'"
	go build -ldflags "${LD_FLAGS}" -o hcloud  cmd/hcloud/main.go 
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin hcloud
}
