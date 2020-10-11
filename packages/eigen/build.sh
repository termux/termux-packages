TERMUX_PKG_HOMEPAGE=http://eigen.tuxfamily.org
TERMUX_PKG_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_VERSION=3.3.8
TERMUX_PKG_SHA256=146a480b8ed1fb6ac7cd33fec9eb5e8f8f62c3683b3f850094d9d5c35a92419a
TERMUX_PKG_SRCURL=https://gitlab.com/libeigen/eigen/-/archive/${TERMUX_PKG_VERSION}/eigen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BREAKS="eigen-dev"
TERMUX_PKG_REPLACES="eigen-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release"
