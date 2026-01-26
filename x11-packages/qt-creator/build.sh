TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Integrated Development Environment for Qt"
TERMUX_PKG_LICENSE="GPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="18.0.2"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qtcreator/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/qt-creator-opensource-src-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e73799b526dbf041487dc5023dd80840d3e722ad476d6995f98cf9a894f6698f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="clang, glib, libandroid-execinfo, libarchive, libelf, libllvm, libsecret, opengl, python, qt6-qtbase, qt6-qtcharts, qt6-qtdeclarative, qt6-qttools, qt6-qtsvg, libyaml-cpp, zstd"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static, qt6-qtbase-cross-tools, qt6-qtcharts-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qttools-cross-tools, qt6-qtsvg-cross-tools"
TERMUX_PKG_RECOMMENDS="gdb, git, make, cmake, mlocate"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_INSTALL_LIBDIR=lib
-DCMAKE_INSTALL_INCLUDEDIR=include
-DBUILD_WITH_PCH=OFF
"

termux_step_pre_configure() {
	termux_setup_golang

	LDFLAGS+=" -landroid-execinfo"

	# add the directories of all .so files found in the package
	# to the library run paths of all executables in the package
	# the 'qtcreator.sh' script sets LD_LIBRARY_PATH automatically so does not
	# seem to need this, but setting these makes the 'qtcreator' binary
	# possible to launch directly without errors.
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/qtcreator"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/qtcreator/plugins"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/qtcreator/plugins/qmldesigner"
}
