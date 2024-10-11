TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Support for icon themes'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.0
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kiconthemes-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2d00b17929d886425395e96c4c18bf5e8dfbf3f1cac2dac199a6f2ac5af35b22
TERMUX_PKG_DEPENDS="kf6-breeze-icons, kf6-karchive, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-ki18n, kf6-kwidgetsaddons, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_RECOMMENDS="qt6-qtdeclarative"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
