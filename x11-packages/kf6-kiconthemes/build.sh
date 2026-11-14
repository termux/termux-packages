TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/kiconthemes'
TERMUX_PKG_DESCRIPTION='Support for icon themes'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.32.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kiconthemes-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=1bd4fe3246af5527c136afc650703e5231b8b2de32ca1eac48fa310adece8db8
TERMUX_PKG_DEPENDS="kf6-breeze-icons (>= ${TERMUX_PKG_VERSION%.*}), kf6-karchive (>= ${TERMUX_PKG_VERSION%.*}), kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-kconfigwidgets (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION%.*}), libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qtsvg, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
