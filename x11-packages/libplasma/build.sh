TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/libplasma"
TERMUX_PKG_DESCRIPTION="Plasma library and runtime components"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/libplasma-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="ab0f4b426829821e0abf479052f326a5ce01c3b604e890c9f79949c3eb5fdebe"
TERMUX_PKG_DEPENDS="libc++, libx11, libxcb, libglvnd, libwayland, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kglobalaccel, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-knotifications, kf6-kpackage, kf6-ksvg, kf6-kwidgetsaddons, kf6-kwindowsystem, plasma-activities, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
