TERMUX_PKG_HOMEPAGE=https://openvpn.net
TERMUX_PKG_DESCRIPTION="An easy-to-use, robust, and highly configurable VPN (Virtual Private Network)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.5.8
TERMUX_PKG_SRCURL=https://swupdate.openvpn.net/community/releases/openvpn-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2bbd0026469902037ee6499b68283d5ab36c74e36cae3112082cfdf6c77a0c57
TERMUX_PKG_DEPENDS="liblz4, liblzo, net-tools, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-plugin-auth-pam
--disable-systemd
--disable-debug
--enable-iproute2
--enable-small
--enable-x509-alt-username
ac_cv_func_getpwnam=yes
IFCONFIG=$TERMUX_PREFIX/bin/ifconfig
ROUTE=$TERMUX_PREFIX/bin/route
IPROUTE=$TERMUX_PREFIX/bin/ip
NETSTAT=$TERMUX_PREFIX/bin/netstat
"

termux_step_post_make_install() {
	# Examples.
	install -d -m700 "$TERMUX_PREFIX/share/openvpn/examples"
	cp "$TERMUX_PKG_SRCDIR"/sample/sample-config-files/* "$TERMUX_PREFIX/share/openvpn/examples"
}
