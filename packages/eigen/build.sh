TERMUX_PKG_HOMEPAGE=http://eigen.tuxfamily.org
TERMUX_PKG_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.0.1"
TERMUX_PKG_SHA256=e9c326dc8c05cd1e044c71f30f1b2e34a6161a3b6ecf445d56b53ff1669e3dec
TERMUX_PKG_SRCURL=https://gitlab.com/libeigen/eigen/-/archive/${TERMUX_PKG_VERSION}/eigen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BREAKS="eigen-dev"
TERMUX_PKG_REPLACES="eigen-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release"
TERMUX_PKG_GROUPS="science"
