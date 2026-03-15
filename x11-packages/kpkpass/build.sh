TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kpkpass"
TERMUX_PKG_DESCRIPTION="Apple Wallet Pass reader"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kpkpass-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="f916bdc37c11740cc527ee76a1326d3457ed9bf153d609cdb5ea7bb581885df9"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
