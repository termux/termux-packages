TERMUX_PKG_HOMEPAGE="https://github.com/rlancaste/stellarsolver"
TERMUX_PKG_DESCRIPTION="Source Extractor and Astrometry.net-Based Internal Astrometric Solver"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="2.9"
TERMUX_PKG_SRCURL="https://github.com/rlancaste/stellarsolver/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=8eccfc6fb3fdc6bf95bf9b49a6d609b5bc8d3b8d2a82549562478d674b303da7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cfitsio, gsl, libc++, qt6-qtbase, wcslib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
