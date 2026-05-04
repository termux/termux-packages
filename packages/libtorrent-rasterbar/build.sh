TERMUX_PKG_HOMEPAGE=https://libtorrent.org/
TERMUX_PKG_DESCRIPTION="A feature complete C++ bittorrent implementation focusing on efficiency and scalability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.12"
TERMUX_PKG_SRCURL="https://github.com/arvidn/libtorrent/releases/download/v${TERMUX_PKG_VERSION}/libtorrent-rasterbar-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=25b898d02e02e43ee9a8ea5480c20007f129091b5754d0283f94e4d51d11a19e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, libc++, openssl, python"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_LIBDIR=$TERMUX__PREFIX__LIB_SUBDIR
-DCMAKE_INSTALL_INCLUDEDIR=$TERMUX__PREFIX__INCLUDE_SUBDIR
-Dboost-python-module-name=python
-Dpython-bindings=ON
"

termux_step_pre_configure() {
	# We don't get build-python in path until termux_setup_python_pip is called in
	# termux_step_get_dependencies_python
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPython3_EXECUTABLE=$(command -v build-python)"
}
