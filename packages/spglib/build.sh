TERMUX_PKG_HOMEPAGE="https://spglib.github.io/spglib/index.html"
TERMUX_PKG_DESCRIPTION="C library for finding and handling crystal symmetries"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.7.0"
TERMUX_PKG_SRCURL="https://github.com/spglib/spglib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=b22fc9abae9716c574fbc6d55cfc53ed654a714fccc5657a26ff5d18114bd8bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSPGLIB_USE_OMP=ON
-DSPGLIB_WITH_Fortran=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
