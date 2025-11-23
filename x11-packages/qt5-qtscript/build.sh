TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt script module"
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0, GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE.FDL, LICENSE.GPL2, LICENSE.GPL3, LICENSE.GPL3-EXCEPT, LICENSE.LGPL3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.15.18"
TERMUX_PKG_SRCURL="https://download.qt.io/archive/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtscript-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=6716d2878d2146f13f11f0fb12f3437c09d85033bdd0684efacb43ea00fa1828
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
	find "${TERMUX_PREFIX}/lib" -type f -name "libQt5Script*.prl" \
		-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

	## Remove *.la files.
	find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}
