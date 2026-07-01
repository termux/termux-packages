TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kitinerary"
TERMUX_PKG_DESCRIPTION="Data model and extraction system for travel reservation information"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kitinerary-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="86eea983c969fa1fed2bdc22a46f800c02b66c512087da6f0072324d28e6d5c6"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcalendarcore, kf6-kcodecs, kf6-kcontacts, kf6-ki18n, kmime, kpkpass, libc++, libxml2, libzxing-cpp, openssl, poppler, qt6-qtbase, qt6-qtdeclarative, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
