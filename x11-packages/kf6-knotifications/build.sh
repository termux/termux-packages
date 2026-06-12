TERMUX_PKG_HOMEPAGE='https://invent.kde.org/frameworks/knotifications'
TERMUX_PKG_DESCRIPTION='Abstraction for system notifications'
TERMUX_PKG_LICENSE="LGPL-2.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.27.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/frameworks/${TERMUX_PKG_VERSION%.*}/knotifications-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=eeb067fab001dd24735ad56e8ec4808fca76e5ecdf003cf614246c9abe1c3e19
TERMUX_PKG_DEPENDS="kf6-kconfig (>= ${TERMUX_PKG_VERSION%.*}), libc++, libcanberra, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules (>= ${TERMUX_PKG_VERSION%.*}), qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_PYTHON_BINDINGS=OFF
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
