TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.0
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://github.com/v2fly/geoip/releases/download/202303020053/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		4cd53acc7e2896cab0cbdd39fd43fd6fc60073be6a025f4fb80710e6bb55090e
	termux_download https://github.com/v2fly/domain-list-community/releases/download/20230306032504/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		5a2f8f3945911e1e7fbf8971d3a24de17f3e7479ba837ff2281a6d03448bbbed
	termux_download https://github.com/v2fly/geoip/releases/download/202303020053/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		9578e6cd3a49b5111f46d1ca7bc9e736f1c16d34625c1c0bf061d23485335b5b
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
