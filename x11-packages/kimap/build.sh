TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kimap"
TERMUX_PKG_DESCRIPTION="Job-based API for interacting with IMAP servers"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kimap-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f11dffa184c7ebe55e1a221b015f4bc51f8c66b5de84579c69d82c151d247f57
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kmime, libc++, libsasl, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
