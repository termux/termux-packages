TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/libktorrent"
TERMUX_PKG_DESCRIPTION="A BitTorrent protocol implementation"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libktorrent-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4c7ef4b7416fcedf9d1ca8b759cae8ee0cd4254dca80e3978753399445dcf008
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, libc++, libgmp, openssl, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
