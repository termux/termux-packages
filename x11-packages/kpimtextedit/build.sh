TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kpimtextedit"
TERMUX_PKG_DESCRIPTION="A textedit with PIM-specific features"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kpimtextedit-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="4ded190adebacdd024dd12f730a26dcf9159c5dcb21f8af18cda973c78cac3b9"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-sonnet, kf6-syntax-highlighting, ktextaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
