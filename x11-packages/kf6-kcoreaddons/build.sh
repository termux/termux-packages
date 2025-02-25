TERMUX_PKG_HOMEPAGE=https://www.kde.org/
TERMUX_PKG_DESCRIPTION="Utilities for core application functionality and accessing the OS (KDE)"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.11.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/kcoreaddons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ff691c6e0933493ea3e8c4a0ba41fa46ced7b9394e6f35ef9dee349ccfcc3a39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION}), qt6-qttools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
