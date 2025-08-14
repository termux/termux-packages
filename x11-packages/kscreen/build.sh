TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kscreen"
TERMUX_PKG_DESCRIPTION="KDE screen management software"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.4"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kscreen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="5890d24614ac6f93cc97964f9ca8b1bef95ec14508408dc87f3904d03b3af876"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kirigami, kf6-kitemmodels, kf6-ksvg, kf6-kwindowsystem, layer-shell-qt, libkscreen, libplasma, libx11, libxcb, libxi, plasma5support, qt6-qtbase, qt6-qtdeclarative, qt6-qtsensors, qt6-qtwayland, libwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
