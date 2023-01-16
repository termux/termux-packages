TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.1
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://github.com/v2fly/geoip/releases/download/202301120046/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		1af779bf9ba759be7590be3b3baf83d7e5c686b003f6f39dd3ab0e847eaedb72
	termux_download https://github.com/v2fly/domain-list-community/releases/download/20230115062500/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		da45c5ca07a05b746d6e67c5d0ea3d80101c6cf8f5c112f68ea94c33c3d97cf4
	termux_download https://github.com/v2fly/geoip/releases/download/202301120046/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		850ce49fc34abaab94fffcd7f9c45ce087cd873a793fb67c8fa850f3facf8afa
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
