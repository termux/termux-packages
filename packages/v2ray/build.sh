TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.1.0
TERMUX_PKG_SRCURL=https://github.com/v2fly/v2ray-core.git
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://raw.githubusercontent.com/v2fly/geoip/release/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		20f6ceaa1e39a9de5473d94979855fe3eb93a5ba4a272862a58d59c7bd4ae908
	termux_download https://raw.githubusercontent.com/v2fly/domain-list-community/release/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		fcf9f44b34c159fdf3180c53814f028e78f312f7bf89d4f115d8c2914a3339fd
	termux_download https://raw.githubusercontent.com/v2fly/geoip/release/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		7f7c0c011a80148b8070ce7dde40db20e222b309ff5ab5c8008e696196830c22
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
