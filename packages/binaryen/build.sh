TERMUX_PKG_HOMEPAGE=https://github.com/WebAssembly/binaryen
TERMUX_PKG_DESCRIPTION="Binaryen is a compiler and toolchain infrastructure library for WebAssembly"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="112"
TERMUX_PKG_SRCURL=https://github.com/WebAssembly/binaryen/archive/version_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=815cb5be322d97829b38ba246c1a657c227e9eea6bfab74cdf0e542c9e5220f8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_TESTS=OFF
"
