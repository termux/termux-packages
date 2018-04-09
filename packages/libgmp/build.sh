TERMUX_PKG_HOMEPAGE=https://gmplib.org/
TERMUX_PKG_DESCRIPTION="Library for arbitrary precision arithmetic"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_VERSION=6.1.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gmp/gmp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cxx"

termux_step_pre_configure() {
# the cxx tests fail because it won't link properly without this
    CXXFLAGS+=" -L$TERMUX_PREFIX/lib"
}
