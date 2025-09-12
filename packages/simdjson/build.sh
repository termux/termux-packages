TERMUX_PKG_HOMEPAGE=https://simdjson.org/
TERMUX_PKG_DESCRIPTION="A C++ library to see how fast we can parse JSON with complete validation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.0"
TERMUX_PKG_SRCURL=https://github.com/simdjson/simdjson/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad238fc578a4c18d3263250d0efaacadbc6a98f9c7b6be2e70867011b627fa57
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
