TERMUX_PKG_HOMEPAGE='https://community.kde.org/Frameworks'
TERMUX_PKG_DESCRIPTION='Abstraction for system notifications'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.21.0"
_KF6_MINOR_VERSION="${TERMUX_PKG_VERSION%.*}"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/frameworks/${_KF6_MINOR_VERSION}/knotifications-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5c9e3ead502f7dbc6835255d55fb33dbe4ad66295877ff08ab221a42db0805ad
TERMUX_PKG_DEPENDS="kf6-kconfig (>= ${_KF6_MINOR_VERSION}), libc++, libcanberra, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${_KF6_MINOR_VERSION}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
