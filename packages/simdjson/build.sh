TERMUX_PKG_HOMEPAGE=https://simdjson.org/
TERMUX_PKG_DESCRIPTION="A C++ library to see how fast we can parse JSON with complete validation"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.0"
TERMUX_PKG_SRCURL=https://github.com/simdjson/simdjson/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf294f624bab25d6e48f2c5380192f839055a7c0e82a77b454f5fcefdb02d07f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
