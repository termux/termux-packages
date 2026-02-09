TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/kpimtextedit"
TERMUX_PKG_DESCRIPTION="A textedit with PIM-specific features"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kpimtextedit-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="100f5dd703adea988f63f2975034a0eff3d4e7d55d088009b02031dc0e47b9c5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcodecs, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-sonnet, kf6-syntax-highlighting, ktextaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
