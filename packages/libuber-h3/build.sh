TERMUX_PKG_HOMEPAGE=https://h3geo.org/
TERMUX_PKG_DESCRIPTION="A hexagonal hierarchical geospatial indexing system"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.2.1"
TERMUX_PKG_SRCURL=https://github.com/uber/h3/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1b51822b43f3887767c5a5aafd958fca72b72fc454f3b3f6eeea31757d74687d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
