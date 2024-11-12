TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Qt library that implements the Open Collaboration Services API'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/attica-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=44300a2d0ed465d9adb0023fac6d67b3b29bec299a54fea3ff3477d9118d1fdd
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
