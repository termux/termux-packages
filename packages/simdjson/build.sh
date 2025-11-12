TERMUX_PKG_HOMEPAGE=https://simdjson.org/
TERMUX_PKG_DESCRIPTION="A C++ library to see how fast we can parse JSON with complete validation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.2"
TERMUX_PKG_SRCURL=https://github.com/simdjson/simdjson/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3efae22cb41f83299fe0b2e8a187af543d3dda93abbb910586f897df670f9eaa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
