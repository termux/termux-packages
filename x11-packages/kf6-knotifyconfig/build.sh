TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/knotifyconfig'
TERMUX_PKG_DESCRIPTION='Configuration system for KNotify'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.28.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/knotifyconfig-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="142cb399c5b55ed0d85f752f8fbb3db3f5930cbfa09737fdb17af6c2dfa073f6"
TERMUX_PKG_DEPENDS="kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), kf6-ki18n (>= ${TERMUX_PKG_VERSION%.*}), kf6-kio (>= ${TERMUX_PKG_VERSION%.*}), libc++, libcanberra, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
