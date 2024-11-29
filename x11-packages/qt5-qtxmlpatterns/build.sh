TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt XmlPatterns Library"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.15.16"
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/${TERMUX_PKG_VERSION%.*}/${TERMUX_PKG_VERSION}/submodules/qtxmlpatterns-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1c853123f0f11a597eee870cfc6247c2569b0fd14bd36de4e32e040575d87940
TERMUX_PKG_DEPENDS="libc++, qt5-qtbase, qt5-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure () {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross"
}

termux_step_post_make_install() {
	## Drop QMAKE_PRL_BUILD_DIR because reference the build dir.
	find "${TERMUX_PREFIX}/lib" -type f -name "libQt5XmlPatterns*.prl" \
		-exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' "{}" \;

	## Remove *.la files.
	find "${TERMUX_PREFIX}/lib" -iname \*.la -delete
}
