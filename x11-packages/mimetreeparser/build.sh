TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mimetreeparser"
TERMUX_PKG_DESCRIPTION="Parser for MIME trees"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mimetreeparser-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="f15b6268261255888e3e986d67b8f39f0d57144e87d99b46e8fabe78cad300dc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gpgmepp, kf6-kcalendarcore, kf6-kcolorscheme, kf6-ki18n, kf6-kirigami, kf6-kwidgetsaddons, kmbox, kmime, libc++, libkleo, qgpgme, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
