TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='A style for Qt Quick Controls 2 to make it follow your desktop theme'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.9.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/qqc2-desktop-style-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3e9c0698e7b392b1110c016d632bce21b32f81e65adfda285b6d01d6d6eb4469
TERMUX_PKG_DEPENDS="kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION}), kf6-kconfig (>= ${TERMUX_PKG_VERSION}), kf6-kiconthemes (>= ${TERMUX_PKG_VERSION}), kf6-kirigami (>= ${TERMUX_PKG_VERSION}), kf6-sonnet (>= ${TERMUX_PKG_VERSION}), libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
