TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.3.0
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://github.com/v2fly/geoip/releases/download/202302090046/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		38e200a655c3e401dde6a438e79d493c3dbdd224e104a5158bef01f78ad4a151
	termux_download https://github.com/v2fly/domain-list-community/releases/download/20230210153419/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		2a92cd713c1f275efa0a307b232ae485dee9394f621597fa434503e5a0ed97e2
	termux_download https://github.com/v2fly/geoip/releases/download/202302090046/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		827097e93035f76c336b868def3bb706dfad9aea2ce189f753078d9733d16ed3
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
