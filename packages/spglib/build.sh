TERMUX_PKG_HOMEPAGE="https://spglib.github.io/spglib/index.html"
TERMUX_PKG_DESCRIPTION="C library for finding and handling crystal symmetries"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/spglib/spglib/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c65af71136c915352eb82444b165ec83289877eb8e46593033f199801b43dbf7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DSPGLIB_USE_OMP=ON
-DSPGLIB_WITH_Fortran=OFF
"

termux_step_pre_configure() {
	LDFLAGS+=" -fopenmp -static-openmp"
}
