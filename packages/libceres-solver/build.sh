TERMUX_PKG_HOMEPAGE="http://ceres-solver.org"
TERMUX_PKG_DESCRIPTION="C++ library for modeling and solving large, complicated optimization problems"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.0"
TERMUX_PKG_SRCURL="http://ceres-solver.org/ceres-solver-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=f7d74eecde0aed75bfc51ec48c91d01fe16a6bf16bce1987a7073286701e2fc6
TERMUX_PKG_DEPENDS="eigen, google-glog, gflags"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DMINIGLOG=ON
"

