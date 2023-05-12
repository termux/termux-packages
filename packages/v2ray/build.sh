TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://github.com/v2fly/geoip/releases/download/202303230043/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		7086861a6016319264248baea07b3fee74d44521f46ead4338f14cb2dd4779a6
	termux_download https://github.com/v2fly/domain-list-community/releases/download/20230324131400/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		7b20a6e466e985f0c6301fb77b00f56367987dd85ef7ea01cb4a72b11d118f89
	termux_download https://github.com/v2fly/geoip/releases/download/202303230043/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		ed3d13a5cf8c9629d5f74b9ee2dd645b90760bae3939b5de8f6b5eb415cfca07
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
