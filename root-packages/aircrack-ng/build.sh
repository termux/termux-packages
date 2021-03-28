TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org/
TERMUX_PKG_DESCRIPTION="WiFi security auditing tools suite"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:1.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/aircrack-ng/aircrack-ng/archive/${TERMUX_PKG_VERSION:2}.tar.gz
TERMUX_PKG_SHA256=c9e7894ba30f5e45b8a20ec43b4599225ac739a795a5bdb98e3f1bbb854d54f7
TERMUX_PKG_DEPENDS="libc++, libnl, openssl, libpcap, pciutils, ethtool"
# static build gives errors:
#   error: undefined reference to 'ac_crypto_engine_init'
#   error: cannot find the library 'libaircrack-ce-wpa.la' or unhandled argument 'libaircrack-ce-wpa.la'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}

termux_step_post_make_install() {
	ln -sf libaircrack-ce-wpa-1.6.0.so $TERMUX_PREFIX/lib/libaircrack-ce-wpa.so
}
