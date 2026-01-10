TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/knotifyconfig'
TERMUX_PKG_DESCRIPTION='Configuration system for KNotify'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.22.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/knotifyconfig-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=14c6864a1e18d06f778d432fb7a186b036e593f372184b97208c7ddddfa39db4
TERMUX_PKG_DEPENDS="kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), kf6-kio (>= ${TERMUX_PKG_VERSION%.*}), libc++, libcanberra, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
