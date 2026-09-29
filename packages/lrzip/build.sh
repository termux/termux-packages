TERMUX_PKG_HOMEPAGE=https://github.com/ckolivas/lrzip
TERMUX_PKG_DESCRIPTION="A compression utility that excels at compressing large files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.660"
TERMUX_PKG_SRCURL="https://github.com/ckolivas/lrzip/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fd2cb18fc166e565a23f3415306d71a0f9151e0f1d7016d9a2c7eb038cd3c159
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
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
