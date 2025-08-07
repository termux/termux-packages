TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kidletime"
TERMUX_PKG_DESCRIPTION="Monitoring user activity"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.16.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kidletime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="57a7a40d7093d7a6697f9a43ff55cbcb2629ec5d28ece4a37aa4000efaa61b2d"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libx11, libxcb, libxext, libxss, qt6-qtbase, qt6-qtwayland, libwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libxss, plasma-wayland-protocols, qt6-qttools, qt6-qtwayland, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
