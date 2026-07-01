TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/khealthcertificate"
TERMUX_PKG_DESCRIPTION="Handling of digital vaccination, test and recovery certificates"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/khealthcertificate-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6061c8eef460ff7555a1f15e69c5c03e009ab907069a183be960b1807f5576c3"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcodecs, kf6-ki18n, libc++, openssl, qt6-qtbase, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtdeclarative"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
