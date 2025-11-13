TERMUX_PKG_HOMEPAGE=https://abseil.io/
TERMUX_PKG_DESCRIPTION="Abseil C++ Common Libraries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Do not forget to rebuild revdeps along with EVERY "major" version bump.
TERMUX_PKG_VERSION="20250814.1"
TERMUX_PKG_SRCURL=https://github.com/abseil/abseil-cpp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1692f77d1739bacf3f94337188b78583cf09bab7e420d2dc6c5605a4f86785a1
# updating this will break libprotobuf
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="libgrpc (<< 1.52.0-1)"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
