TERMUX_PKG_HOMEPAGE=https://h3geo.org/
TERMUX_PKG_DESCRIPTION="A hexagonal hierarchical geospatial indexing system"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.4.1"
TERMUX_PKG_SRCURL=https://github.com/uber/h3/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9df719eb878f218c203e424dc5ffca9b98eca4d78ba83928773987649ead404d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
