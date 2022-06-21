TERMUX_PKG_HOMEPAGE="https://www.aircrack-ng.org/"
TERMUX_PKG_DESCRIPTION="WiFi security auditing tools suite"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
TERMUX_PKG_VERSION="1.7"
TERMUX_PKG_SRCURL="https://github.com/aircrack-ng/aircrack-ng/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="05a704e3c8f7792a17315080a21214a4448fd2452c1b0dd5226a3a55f90b58c3"
TERMUX_PKG_DEPENDS="libc++, libnl, openssl, libpcap"
# static build gives errors:
#   error: undefined reference to 'ac_crypto_engine_init'
#   error: cannot find the library 'libaircrack-ce-wpa.la' or unhandled argument 'libaircrack-ce-wpa.la'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
        NOCONFIGURE=1 ./autogen.sh
}

termux_step_post_make_install() {
        ln -sf libaircrack-ce-wpa-1.6.0.so $TERMUX_PREFIX/lib/libaircrack-ce-wpa.so
}
