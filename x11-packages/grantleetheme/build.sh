TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/grantleetheme"
TERMUX_PKG_DESCRIPTION="Library for Grantlee theming support"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/grantleetheme-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=53d5bc8fb1e219077ff9e288a792d0d9de0b3f54cf20fdd0bb75e61e0b79b570
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-knewstuff, kf6-ktexttemplate, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
