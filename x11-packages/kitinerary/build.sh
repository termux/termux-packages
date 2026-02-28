TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kitinerary"
TERMUX_PKG_DESCRIPTION="Data model and extraction system for travel reservation information"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kitinerary-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="dd8374be2e4c488902f6c0b4b9fd12ad7f808de23b7df4561ef30b3f79b44d13"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcalendarcore, kf6-kcodecs, kf6-kcontacts, kf6-ki18n, kmime, kpkpass, libc++, libxml2, libzxing-cpp, openssl, poppler, qt6-qtbase, qt6-qtdeclarative, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
