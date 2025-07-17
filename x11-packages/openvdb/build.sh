TERMUX_PKG_HOMEPAGE=https://www.openvdb.org/
TERMUX_PKG_DESCRIPTION="Sparse volume data structure and tools"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="12.0.1"
TERMUX_PKG_SRCURL="https://github.com/AcademySoftwareFoundation/openvdb/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a3c8724ecadabaf558b6e1bd6f1d695e93b82a7cfdf144b8551e5253340ddce0
TERMUX_PKG_DEPENDS="boost, imath, libblosc, libtbb, zlib"
TERMUX_PKG_BUILD_DEPENDS="mesa, glfw, glu"
TERMUX_PKG_AUTO_UPDATE=true
# Numpy support requires nanobind which is not packaged at time of writing
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_IMATH_HALF=ON
-DUSE_NUMPY=OFF
-DUSE_LOG4CPLUS=OFF
-DOPENVDB_BUILD_PYTHON_MODULE=OFF
-DOPENVDB_BUILD_DOCS=OFF
-DOPENVDB_BUILD_UNITTESTS=OFF
"
