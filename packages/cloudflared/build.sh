TERMUX_PKG_HOMEPAGE=https://github.com/cloudflare/cloudflared
TERMUX_PKG_DESCRIPTION="A tunneling daemon that proxies traffic from the Cloudflare network to your origins"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.3.2
TERMUX_PKG_SRCURL=https://github.com/cloudflare/cloudflared/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=58ed53896b7ee2cc4ac84ec2d6f47423476b4292a56b5379aa9715103a4cb226
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local _VERSION=$TERMUX_PKG_VERSION
	local _DATE=$(date -u +%Y.%m.%d-%H:%M UTC)
	go build -ldflags "-X \"main.Version=$_VERSION\" -X \"main.BuildTime=$_DATE\"" \
		./cmd/cloudflared
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin cloudflared
}
