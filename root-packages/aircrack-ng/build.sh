TERMUX_PKG_HOMEPAGE="https://www.aircrack-ng.org/"
TERMUX_PKG_DESCRIPTION="WiFi security auditing tools suite"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Marlin Sööse <marlin.soose@laro.se>"
_COMMIT=f94a3fe3f1c74938169317a6395b7f72452499c4
TERMUX_PKG_VERSION="2:2021.12.19-${_COMMIT:0:8}"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/aircrack-ng/aircrack-ng/archive/$_COMMIT.tar.gz"
TERMUX_PKG_SHA256="d79c02351fe389c41e6c29ef4381109f78ae5f3ba552f776ee08b6a3cbd3aa13"
TERMUX_PKG_DEPENDS="libc++, libnl, openssl, libpcap"
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
