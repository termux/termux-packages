TERMUX_PKG_HOMEPAGE=https://github.com/JuliaLang/utf8proc
TERMUX_PKG_DESCRIPTION="Library for processing UTF-8 Unicode data"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.1
TERMUX_PKG_SRCURL=https://github.com/JuliaLang/utf8proc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4c06a9dc4017e8a2438ef80ee371d45868bda2237a98b26554de7a95406b283b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="utf8proc-dev"
TERMUX_PKG_REPLACES="utf8proc-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/CMakeLists.txt
}
