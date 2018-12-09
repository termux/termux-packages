TERMUX_PKG_HOMEPAGE=http://eigen.tuxfamily.org
TERMUX_PKG_DESCRIPTION="Eigen is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms"
TERMUX_PKG_VERSION=3.3.5
TERMUX_PKG_SHA256=7352bff3ea299e4c7d7fbe31c504f8eb9149d7e685dec5a12fbaa26379f603e2
TERMUX_PKG_SRCURL=http://bitbucket.org/eigen/eigen/get/${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DCMAKE_BUILD_TYPE=Release"
