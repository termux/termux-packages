TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kimap"
TERMUX_PKG_DESCRIPTION="Job-based API for interacting with IMAP servers"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kimap-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="0cdb8c01869f82891375f5c7587f02ef8a751e68031aed94e3d0b47f301fc9a8"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcoreaddons, kf6-ki18n, kf6-kio, kmime, libc++, libsasl, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
