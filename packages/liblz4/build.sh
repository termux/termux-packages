TERMUX_PKG_HOMEPAGE=https://lz4.github.io/lz4/
TERMUX_PKG_DESCRIPTION="Fast LZ compression algorithm library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.3
TERMUX_PKG_SRCURL=https://github.com/lz4/lz4/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=030644df4611007ff7dc962d981f390361e6c97a34e5cbc393ddfbe019ffe2c1
TERMUX_PKG_BREAKS="liblz4-dev"
TERMUX_PKG_REPLACES="liblz4-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+=lib
}

# Do not execute this step since on `make install` it will
# recompile libraries & tools again.
termux_step_make() {
	:
}
