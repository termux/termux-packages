TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kidentitymanagement"
TERMUX_PKG_DESCRIPTION="Library to assist in handling user identities"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kidentitymanagement-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="18b24c23bd6fdb5e617b0cd7c7b2ce1da6ffb566e309c796176691c633d49e87"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kwidgetsaddons, kf6-kxmlgui, kpimtextedit, ktextaddons, libc++, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kirigami-addons"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
