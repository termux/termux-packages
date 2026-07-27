TERMUX_PKG_HOMEPAGE="https://github.com/rlancaste/stellarsolver"
TERMUX_PKG_DESCRIPTION="Source Extractor and Astrometry.net-Based Internal Astrometric Solver"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="2.8"
TERMUX_PKG_SRCURL="https://github.com/rlancaste/stellarsolver/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1456cac5cd67353e19e1c6e57546af052a9302b7fbe2deaa649a44eec45fbec8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cfitsio, gsl, libc++, qt6-qtbase, wcslib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
