TERMUX_PKG_HOMEPAGE=https://cmake-python-distributions.readthedocs.io/
TERMUX_PKG_DESCRIPTION="Python wrapper for CMake"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.3"
TERMUX_PKG_SRCURL="https://github.com/scikit-build/cmake-python-distributions/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=ecb64be29518930f7f21c47bdcf9eaa9b0cbd6cab23bdc755766d5408a138ec0
TERMUX_PKG_DEPENDS="cmake, cmake-curses-gui, python, python-pip"
TERMUX_PKG_SETUP_PYTHON=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	termux_setup_cmake
	# prevent any downloading or compiling of CMake source code,
	# but allow the normal installation of all other files
	mkdir -p empty
	echo 'cmake_minimum_required(VERSION 4.0)' > CMakeLists.txt
	echo 'install(DIRECTORY empty DESTINATION "${CMAKE_INSTALL_PREFIX}")' >> CMakeLists.txt
}
