TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/attica'
TERMUX_PKG_DESCRIPTION='Qt library that implements the Open Collaboration Services API'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.23.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/attica-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d6f85ede23fd9fcaa682444a28a85ba117cdee9b81706b5ad6ad644af8a8f357
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
