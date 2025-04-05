TERMUX_PKG_HOMEPAGE=https://include-what-you-use.org/
TERMUX_PKG_DESCRIPTION="A tool to analyze #includes in C and C++ source files"
TERMUX_PKG_LICENSE=NCSA
TERMUX_PKG_MAINTAINER="@termux"
# Update this and the clang version below when libllvm is updated:
TERMUX_PKG_VERSION=0.24
TERMUX_PKG_SRCURL=https://github.com/include-what-you-use/include-what-you-use/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=897b4c864a983f493c8efef4a1a9a2d429fd7ead1011f7a41743ed7b6dbe8c2e
TERMUX_PKG_AUTO_UPDATE=false # can't be auto-updated since release correspond to clang version.
TERMUX_PKG_DEPENDS="clang (>= 20), clang (<< 21), libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
