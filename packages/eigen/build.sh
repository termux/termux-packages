TERMUX_PKG_HOMEPAGE=http://eigen.tuxfamily.org
TERMUX_PKG_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.9
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=7985975b787340124786f092b3a07d594b2e9cd53bbfe5f3d9b1daee7d55f56f
TERMUX_PKG_SRCURL=https://gitlab.com/libeigen/eigen/-/archive/${TERMUX_PKG_VERSION}/eigen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BREAKS="eigen-dev"
TERMUX_PKG_REPLACES="eigen-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release"
