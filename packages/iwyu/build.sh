TERMUX_PKG_HOMEPAGE=https://include-what-you-use.org/
TERMUX_PKG_DESCRIPTION="A tool to analyze #includes in C and C++ source files"
TERMUX_PKG_LICENSE=NCSA
TERMUX_PKG_MAINTAINER="@termux"
# Update this when libllvm is updated:
TERMUX_PKG_VERSION=0.23
TERMUX_PKG_SRCURL=https://github.com/include-what-you-use/include-what-you-use/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=16672743fdf781d7db313f48c7f4b34bc6517eddfd92d7db793790fe793a306c
TERMUX_PKG_AUTO_UPDATE=false # can't be auto-updated since release correspond to clang version.
TERMUX_PKG_DEPENDS="clang, libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
