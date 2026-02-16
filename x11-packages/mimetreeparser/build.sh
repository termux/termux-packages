TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mimetreeparser"
TERMUX_PKG_DESCRIPTION="Parser for MIME trees"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mimetreeparser-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="bdd46f111fa707b2c2f2bd6621af436d0a29ebcc8b98ae5a4facb022161cd91e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gpgmepp, kf6-kcalendarcore, kf6-kcolorscheme, kf6-ki18n, kf6-kirigami, kf6-kwidgetsaddons, kmbox, kmime, libc++, libkleo, qgpgme, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
