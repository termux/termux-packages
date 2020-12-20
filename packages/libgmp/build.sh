TERMUX_PKG_HOMEPAGE=https://gmplib.org/
TERMUX_PKG_DESCRIPTION="Library for arbitrary precision arithmetic"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.2.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gmp/gmp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2
TERMUX_PKG_BREAKS="libgmp-dev"
TERMUX_PKG_REPLACES="libgmp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cxx"

termux_step_pre_configure() {
# the cxx tests fail because it won't link properly without this
    CXXFLAGS+=" -L$TERMUX_PREFIX/lib"
}
