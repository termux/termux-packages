TERMUX_PKG_HOMEPAGE=https://www.v2fly.org/
TERMUX_PKG_DESCRIPTION="A platform for building proxies to bypass network restrictions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.2.0
TERMUX_PKG_SRCURL=git+https://github.com/v2fly/v2ray-core
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	termux_setup_golang
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go get
	chmod +w $GOPATH -R
	rm -rf $TERMUX_PREFIX/share/v2ray/
	mkdir -p $TERMUX_PREFIX/share/v2ray/
	termux_download https://github.com/v2fly/geoip/releases/download/202212220043/geoip.dat \
		$TERMUX_PREFIX/share/v2ray/geoip.dat \
		2c19f53055777a126a4687feb41dab033180b517de058a0d18b6344c4987f57d
	termux_download https://github.com/v2fly/domain-list-community/releases/download/20221227080615/dlc.dat \
		$TERMUX_PREFIX/share/v2ray/geosite.dat \
		5059e2a43c5050f8ed61ff233975d5c25b81c28b6a3643538d678d0fe51e7a57
	termux_download https://github.com/v2fly/geoip/releases/download/202212220043/geoip-only-cn-private.dat \
		$TERMUX_PREFIX/share/v2ray/geoip-only-cn-private.dat \
		4548c4b9d15f9f98513eba3df6bda2aa1cec06ff9cac85f3ab12a98eb0932b3e
}

termux_step_make() {
	export GOPATH=$TERMUX_PKG_SRCDIR/go
	go build -o v2ray ./main
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin v2ray
	install -Dm600 -t $TERMUX_PREFIX/share/v2ray release/config/*.json
}
