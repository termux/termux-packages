TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/krunner"
TERMUX_PKG_DESCRIPTION="Framework for providing different actions given a string query"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.17.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/krunner-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="9d4a5c0c74b0cfa9e35c31de762633ddec0439c50fa44bc85bec28ada0106912"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kitemmodels, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
