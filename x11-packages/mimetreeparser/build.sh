TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/mimetreeparser"
TERMUX_PKG_DESCRIPTION="Parser for MIME trees"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/mimetreeparser-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b81506a5876039c0aa9969f7bd71040880b171b53014a76a8bbaed02287cc5f9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gpgmepp, kf6-kcalendarcore, kf6-kcolorscheme, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kwidgetsaddons, kmbox, kf6-kmime, libc++, libkleo, qgpgme, qt6-qtbase, qt6-qtdeclarative, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
# qt6-qtwebengine is not supported on the i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
