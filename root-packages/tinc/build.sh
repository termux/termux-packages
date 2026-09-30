TERMUX_PKG_HOMEPAGE=https://www.tinc-vpn.org/
TERMUX_PKG_DESCRIPTION="VPN daemon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.37
TERMUX_PKG_SRCURL=https://www.tinc-vpn.org/packages/tinc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f63b7e21c32c4c637576d85f36bdd28ea678b5aa17fad02427645dea30e52ac7
TERMUX_PKG_DEPENDS="liblzo, openssl, zlib"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	export LIBS="-llog"
}
