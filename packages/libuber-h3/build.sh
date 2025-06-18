TERMUX_PKG_HOMEPAGE=https://h3geo.org/
TERMUX_PKG_DESCRIPTION="A hexagonal hierarchical geospatial indexing system"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.0"
TERMUX_PKG_SRCURL=https://github.com/uber/h3/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a47cfa36e255e4bf16c63015aaff8e6fe2afc14ffaa3f6b281718158446c0e9b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_SHARED_LIBS=ON"

termux_step_pre_configure() {
	LDFLAGS+=" -lm"
}
