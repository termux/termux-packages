TERMUX_PKG_HOMEPAGE=https://gmplib.org/
TERMUX_PKG_DESCRIPTION="Library for arbitrary precision arithmetic"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.3.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gmp/gmp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=a3c2b80201b89e68616f4ad30bc66aee4927c3ce50e33929ca819d5c43538898
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BREAKS="libgmp-dev"
TERMUX_PKG_REPLACES="libgmp-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-cxx"

termux_step_pre_configure() {
	# the cxx tests fail because it won't link properly without this
	CXXFLAGS+=" -L$TERMUX_PREFIX/lib -Wl,-rpath=$TERMUX_PREFIX/lib"
}
