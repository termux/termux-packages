TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Add support for global workspace shortcuts'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.12.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kglobalaccel-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1c5e7e4d9b6862eb36a1f6c23fd9fff4b4bcf0b4fad740bae5ca58e15c8407f4
TERMUX_PKG_DEPENDS="qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), libc++, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
