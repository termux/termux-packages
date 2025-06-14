TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Support for icon themes'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.15.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/kiconthemes-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8842703899722f9ab6b4aec0b45c38bee9896e32daccb3eb17ef014404c9606b
TERMUX_PKG_DEPENDS="kf6-breeze-icons (>= ${_KF6_MINOR_VERSION}), kf6-karchive (>= ${_KF6_MINOR_VERSION}), kf6-kcolorscheme (>= ${_KF6_MINOR_VERSION}), kf6-kconfig (>= ${_KF6_MINOR_VERSION}), kf6-kconfigwidgets (>= ${_KF6_MINOR_VERSION}), kf6-ki18n (>= ${_KF6_MINOR_VERSION}), kf6-kwidgetsaddons (>= ${_KF6_MINOR_VERSION}), libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qtsvg, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
