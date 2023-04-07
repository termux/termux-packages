TERMUX_PKG_HOMEPAGE=https://github.com/ckolivas/lrzip
TERMUX_PKG_DESCRIPTION="A compression utility that excels at compressing large files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.651
TERMUX_PKG_SRCURL=https://github.com/ckolivas/lrzip/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f4c84de778a059123040681fd47c17565fcc4fec0ccc68fcf32d97fad16cd892
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, libbz2, libc++, liblz4, liblzo, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-asm=no
"
# Avoid conflicting with lrzsz.
TERMUX_PKG_RM_AFTER_INSTALL="
bin/lrz
share/man/man1/lrz.1
"

termux_step_pre_configure() {
	autoreconf -fi
}
