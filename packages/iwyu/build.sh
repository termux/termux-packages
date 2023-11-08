TERMUX_PKG_HOMEPAGE=https://include-what-you-use.org/
TERMUX_PKG_DESCRIPTION="A tool to analyze #includes in C and C++ source files"
TERMUX_PKG_LICENSE=NCSA
TERMUX_PKG_MAINTAINER="@termux"
# Update this when libllvm is updated:
TERMUX_PKG_VERSION=0.21
TERMUX_PKG_SRCURL=https://github.com/include-what-you-use/include-what-you-use/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a472fe8587376d041585c72e5643200f8929899f787725f0ba9e5b3d3820d401
TERMUX_PKG_AUTO_UPDATE=false # can't be auto-updated since release correspond to clang version.
TERMUX_PKG_DEPENDS="clang, libc++, python"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static"
