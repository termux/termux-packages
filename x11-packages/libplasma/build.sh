TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/libplasma"
TERMUX_PKG_DESCRIPTION="Plasma library and runtime components"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/libplasma-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7d88f9bd0f90b90f4d2290cd8fa0f37e7af3810a0ed58c7d226a02838ab8a71a
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kglobalaccel, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-knotifications, kf6-kpackage, kf6-ksvg, kf6-kwidgetsaddons, kf6-kwindowsystem, libc++, libglvnd, libwayland, libx11, libxcb, plasma-activities, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
