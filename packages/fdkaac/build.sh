TERMUX_PKG_HOMEPAGE=https://github.com/nu774/fdkaac
TERMUX_PKG_DESCRIPTION="command line encoder frontend for libfdk-aac"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@DLC01"
TERMUX_PKG_VERSION=1.0.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/nu774/fdkaac/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8a0b67792605fb8955d6be78a81e3a4029e9b7d0f594d8ed76e0fbcef90be0c8
TERMUX_PKG_DEPENDS="libfdk-aac"

termux_step_pre_configure() {
	autoreconf -fi
}
