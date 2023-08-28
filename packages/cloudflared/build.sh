TERMUX_PKG_HOMEPAGE=https://github.com/cloudflare/cloudflared
TERMUX_PKG_DESCRIPTION="A tunneling daemon that proxies traffic from the Cloudflare network to your origins"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2023.8.1"
TERMUX_PKG_SRCURL=https://github.com/cloudflare/cloudflared/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e2cbb89bf73220a7bc4491facb96ff16c1880ebfcac679b5b17f21abab039c72
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GO_USE_OLDER=true

termux_step_make() {
	termux_setup_golang

	local _DATE=$(date -u '+%Y.%m.%d-%H:%M UTC')
	go build -v -ldflags "-X \"main.Version=$TERMUX_PKG_VERSION\" -X \"main.BuildTime=$_DATE\"" \
		./cmd/cloudflared
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin cloudflared
}
