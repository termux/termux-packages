TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Widgets for KConfig'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.8.0"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kconfigwidgets-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9dc3a82f1fb32750e6ecf78a863a43226a30e2fcadd7551eec7886916e1cb4f1
TERMUX_PKG_DEPENDS="kf6-kcodecs (>= ${TERMUX_PKG_VERSION}), kf6-kcolorscheme (>= ${TERMUX_PKG_VERSION}), kf6-kconfig (>= ${TERMUX_PKG_VERSION}), kf6-kcoreaddons (>= ${TERMUX_PKG_VERSION}), kf6-ki18n (>= ${TERMUX_PKG_VERSION}), kf6-kwidgetsaddons (>= ${TERMUX_PKG_VERSION}), libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
