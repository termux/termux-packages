TERMUX_PKG_HOMEPAGE=https://abseil.io/
TERMUX_PKG_DESCRIPTION="Abseil C++ Common Libraries"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Do not forget to rebuild revdeps along with EVERY "major" version bump.
TERMUX_PKG_VERSION=20230125.0
TERMUX_PKG_SRCURL=https://github.com/abseil/abseil-cpp/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ea49a7d97421b88a8c48a0de16c16048e17725c7ec0f1d3ea2683a2a75adc21
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
"
