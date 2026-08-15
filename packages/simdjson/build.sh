TERMUX_PKG_HOMEPAGE=https://simdjson.org/
TERMUX_PKG_DESCRIPTION="A C++ library to see how fast we can parse JSON with complete validation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.7"
TERMUX_PKG_SRCURL=https://github.com/simdjson/simdjson/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3bae37c1b215fc28a32db09a8c25513914cbbc1494d768e593d1b9135c8c0fd4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
