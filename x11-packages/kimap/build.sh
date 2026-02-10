TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kimap"
TERMUX_PKG_DESCRIPTION="Job-based API for interacting with IMAP servers"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kimap-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="d445daeedb378481a9ee4cfd65524b4c2f36c9710a65e27f42ddc325ba1fdc71"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-ki18n, kf6-kio, kmime, libc++, libsasl, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
