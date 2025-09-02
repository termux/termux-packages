TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/frameworkintegration"
TERMUX_PKG_DESCRIPTION="Framework providing components to allow applications to integrate with a KDE Workspace"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/frameworkintegration-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="63e414df5ca2e7c10292eee89394eff2987a19e2291b1288851a961828477a5e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kconfig, kf6-ki18n, kf6-kiconthemes, kf6-knewstuff, kf6-knotifications, kf6-kwidgetsaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_SUGGESTS="appstream-qt, packagekit-qt6"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
