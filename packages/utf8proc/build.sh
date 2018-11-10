TERMUX_PKG_HOMEPAGE=https://github.com/JuliaLang/utf8proc
TERMUX_PKG_DESCRIPTION="Library for processing UTF-8 Unicode data"
TERMUX_PKG_VERSION=2.2.0
TERMUX_PKG_SHA256=3f8fd1dbdb057ee5ba584a539d5cd1b3952141c0338557cb0bdf8cb9cfed5dbf
TERMUX_PKG_SRCURL=https://github.com/JuliaLang/utf8proc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/CMakeLists.txt
}
