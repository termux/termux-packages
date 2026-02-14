TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/svg"
TERMUX_PKG_DESCRIPTION="Components for handling SVGs"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/ksvg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=44e302fd89eebb61853884d900d436bc4e0932287a117e69d3bce0aa9763232e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, libc++, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kirigami, qt6-qttools, qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
