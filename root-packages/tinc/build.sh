TERMUX_PKG_HOMEPAGE=https://www.tinc-vpn.org/
TERMUX_PKG_DESCRIPTION="VPN daemon"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.36
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.tinc-vpn.org/packages/tinc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=40f73bb3facc480effe0e771442a706ff0488edea7a5f2505d4ccb2aa8163108
TERMUX_PKG_DEPENDS="liblzo, openssl, zlib"

termux_step_pre_configure() {
	export LIBS="-llog"
}
