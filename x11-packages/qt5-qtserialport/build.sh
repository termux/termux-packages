TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt Serial Port Library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.15.7
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qtserialport-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=20aa3988e1474c64fbb4fd7d84c43c84a03645ec3ee58c3725ff04ea987113a9
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_make_install() {
	make install

	#######################################################
	##
	##  Fixes & cleanup.
	##
	#######################################################

	## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
	find "${TERMUX_PREFIX}/lib" -type f -name "libQt5SerialPort*.prl" \
		-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

	## Remove *.la files.
	find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}
