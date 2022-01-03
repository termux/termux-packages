TERMUX_PKG_HOMEPAGE=http://eigen.tuxfamily.org
TERMUX_PKG_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_SHA256=8586084f71f9bde545ee7fa6d00288b264a2b7ac3607b974e54d13e7162c1c72
TERMUX_PKG_SRCURL=https://gitlab.com/libeigen/eigen/-/archive/${TERMUX_PKG_VERSION}/eigen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BREAKS="eigen-dev"
TERMUX_PKG_REPLACES="eigen-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release"
TERMUX_PKG_GROUPS="science"
