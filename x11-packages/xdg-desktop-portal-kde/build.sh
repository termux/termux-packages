TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/xdg-desktop-portal-kde"
TERMUX_PKG_DESCRIPTION="A backend implementation for xdg-desktop-portal that is using Qt/KDE"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/xdg-desktop-portal-kde-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="626f35baa5e54d242742da61b2428a7d71c2a52d45a03524c8e1001ea37b97ca"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kglobalaccel, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemviews, kf6-knotifications, kf6-kservice, kf6-kstatusnotifieritem, kf6-kwindowsystem, kirigami-addons, kpipewire, kwayland, libc++, libwayland, libxkbcommon, plasma-workspace, qt6-qtbase, qt6-qtdeclarative, xdg-desktop-portal"
TERMUX_PKG_BUILD_DEPENDS="cups, extra-cmake-modules, plasma-wayland-protocols, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
