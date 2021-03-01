TERMUX_PKG_HOMEPAGE=http://hostap.epitest.fi/wpa_supplicant
TERMUX_PKG_DESCRIPTION="Utility providing key negotiation for WPA wireless networks"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.9
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://w1.fi/releases/wpa_supplicant-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="openssl, readline, libnl"
TERMUX_PKG_SHA256=fcbdee7b4a64bea8177973299c8c824419c413ec2e3a95db63dd6a5dc3541f17
TERMUX_PKG_EXTRA_MAKE_ARGS="-C wpa_supplicant"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_configure() {
	cp wpa_supplicant/defconfig wpa_supplicant/.config
	export EXTRA_CFLAGS=$CPPFLAGS
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/{man5,man8}
	install -m600 wpa_supplicant/doc/docbook/wpa_supplicant.conf.5 $TERMUX_PREFIX/share/man/man5/
	install -m600 wpa_supplicant/doc/docbook/{wpa_cli,wpa_supplicant}.8 $TERMUX_PREFIX/share/man/man8/
}
