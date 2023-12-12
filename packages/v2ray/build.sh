TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.13.0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://github.com/v2fly/geoip/releases/download/202306150049/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		811085edc67057690c783e735182db32e5a4b446ee5f6d70ef9e12960ce910da
	termux_download https://github.com/v2fly/domain-list-community/releases/download/20230614081211/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		bc72217e378cf0c726cb1507126f0d5b563096c42832305523a6c4d1806c15a3
	termux_download https://github.com/v2fly/geoip/releases/download/202306150049/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		98f6b3a01e2896e908fc2481d1ebb5da74b204f68ab70ec51c8e525a7ed2515b
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
