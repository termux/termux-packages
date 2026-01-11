TERMUX_PKG_HOMEPAGE=https://riverbankcomputing.com/software/qscintilla
TERMUX_PKG_DESCRIPTION="Qt6 port of the Scintilla editing component"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.14.1"
TERMUX_PKG_SRCURL="https://www.riverbankcomputing.com/static/Downloads/QScintilla/${TERMUX_PKG_VERSION}/QScintilla_src-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=dfe13c6acc9d85dfcba76ccc8061e71a223957a6c02f3c343b30a9d43a4cdd4d
# qt6-qtbase pulls in opengl, but qscintilla-qt6 links directly to opengl libraries as well, so specify it for clarity
TERMUX_PKG_DEPENDS="libc++, opengl, qt6-qtbase"
# qttools is only needed to build Qt Designer's plugins
TERMUX_PKG_BUILD_DEPENDS="libglvnd-dev, qt6-qttools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-C src"

termux_step_configure () {
	pushd "${TERMUX_PKG_SRCDIR}/src"
	# note: 'host-qmake6' appears to correctly set some necessary build settings,
	# such as '-Wl,-rpath,/data/data/com.termux/files/usr/lib'
	# and '-I/data/data/com.termux/files/usr/include/qt6/QtCore',
	# but fails to correctly set some other necessary build settings,
	# like 'aarch64-linux-android-clang++' and '-L/data/data/com.termux/files/usr/lib',
	# so this overrides only the settings that are absolutely necessary to correct,
	# while leaving other settings as they are.
	# also, it's unclear how to successfully pass more than one argument at a time
	# to variables like QMAKE_CXXFLAGS.
	"${TERMUX_PREFIX}/lib/qt6/bin/host-qmake6" \
		QMAKE_CXX="$CXX" \
		QMAKE_LINK="$CXX" \
		QMAKE_CXXFLAGS="-isystem$TERMUX__PREFIX__INCLUDE_DIR" \
		QMAKE_LFLAGS="-L$TERMUX__PREFIX__LIB_DIR"
	popd
}

termux_step_post_make_install() {
	pushd "${TERMUX_PKG_SRCDIR}/designer"
	"${TERMUX_PREFIX}/lib/qt6/bin/host-qmake6" \
		INCLUDEPATH+=../src \
		QMAKE_LIBDIR+=../src \
		QMAKE_CXX="$CXX" \
		QMAKE_LINK="$CXX" \
		QMAKE_CXXFLAGS="-isystem$TERMUX__PREFIX__INCLUDE_DIR" \
		QMAKE_LFLAGS="-L$TERMUX__PREFIX__LIB_DIR"
	make -j "${TERMUX_PKG_MAKE_PROCESSES}"
	make install
	popd
}
