TERMUX_PKG_HOMEPAGE=https://include-what-you-use.org/
TERMUX_PKG_DESCRIPTION="A tool to analyze #includes in C and C++ source files"
TERMUX_PKG_LICENSE=NCSA
TERMUX_PKG_MAINTAINER="@termux"
# Update this and the clang version below when libllvm is updated:
TERMUX_PKG_VERSION="0.25"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/include-what-you-use/include-what-you-use/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2e8381368ec0a6ecb770834bce00fc62efa09a2b2f9710ed569acbb823ead9cc
TERMUX_PKG_AUTO_UPDATE=false # can't be auto-updated since release correspond to clang version.
TERMUX_PKG_DEPENDS="clang (>= 21), clang (<< 22), libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
