TERMUX_PKG_HOMEPAGE=https://h3geo.org/
TERMUX_PKG_DESCRIPTION="A hexagonal hierarchical geospatial indexing system"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5.0"
TERMUX_PKG_SRCURL=https://github.com/uber/h3/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0da8a392a6ff77e76b60e6a331a49497d0935b6b7b6899da7a3e2786139b0441
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
