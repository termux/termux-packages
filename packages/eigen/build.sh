TERMUX_PKG_HOMEPAGE=http://eigen.tuxfamily.org
TERMUX_PKG_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_VERSION=3.3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=9f13cf90dedbe3e52a19f43000d71fdf72e986beb9a5436dddcd61ff9d77a3ce
TERMUX_PKG_SRCURL=https://bitbucket.org/eigen/eigen/get/${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_BREAKS="eigen-dev"
TERMUX_PKG_REPLACES="eigen-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release"
