TERMUX_PKG_HOMEPAGE="https://invent.kde.org/frameworks/kcmutils"
TERMUX_PKG_DESCRIPTION="Utilities for interacting with KCModules"
TERMUX_PKG_LICENSE="LGPL-2.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.18.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kcmutils-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6114c1ec8eb73734619a99e4956dce449828af336c2cd91d19bfeb03e221528f"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemviews, kf6-kservice, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
