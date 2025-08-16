TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kcmutils"
TERMUX_PKG_DESCRIPTION="Utilities for interacting with KCModules"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.17.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kcmutils-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="8f65ef0f4f4f325ad6e2a30cb14242220f811ab1e031416fd3faa544ac683e8a"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemviews, kf6-kservice, kf6-kwidgetsaddons, kf6-kxmlgui, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
