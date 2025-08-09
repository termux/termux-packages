TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/svg"
TERMUX_PKG_DESCRIPTION="Components for handling SVGs"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.17.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/ksvg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="3728da966932f20f190a545a7f42edea2f9bdbe6d727a5bc1b557ef5155b7f94"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-karchive, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools, qt6-qtdeclarative, kf6-kirigami"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
