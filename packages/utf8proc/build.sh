TERMUX_PKG_HOMEPAGE=https://github.com/JuliaLang/utf8proc
TERMUX_PKG_DESCRIPTION="Library for processing UTF-8 Unicode data"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SHA256=c0265a49b59bab95481cab1ae958ba034dedc47ad58676a61f5de1fa9347930e
TERMUX_PKG_SRCURL=https://github.com/JuliaLang/utf8proc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/CMakeLists.txt
}
