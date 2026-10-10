TERMUX_PKG_HOMEPAGE=https://libtorrent.org/
TERMUX_PKG_DESCRIPTION="A feature complete C++ bittorrent implementation focusing on efficiency and scalability"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.1.2"
TERMUX_PKG_SRCURL="https://github.com/arvidn/libtorrent/releases/download/v${TERMUX_PKG_VERSION}/libtorrent-rasterbar-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=3362546d9cd71b9e49ee6cac7d3f1f914ce9cdb217c86b63d5b22cbed0334dbc
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
	# We don't get python in path until termux_setup_python_pip is called in
	# termux_step_get_dependencies_python
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPython3_EXECUTABLE=$(command -v python)"
}
