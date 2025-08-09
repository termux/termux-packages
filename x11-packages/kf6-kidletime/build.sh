TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kidletime"
TERMUX_PKG_DESCRIPTION="Monitoring user activity"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.17.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kidletime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="1f67d26749de9f09f4ab0dc4b23e53ecb84d921b1d52d612822fdc53c34c3b37"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libx11, libxcb, libxext, libxss, qt6-qtbase, qt6-qtwayland, libwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libxss, plasma-wayland-protocols, qt6-qttools, qt6-qtwayland, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
