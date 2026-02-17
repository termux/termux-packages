TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kde-gtk-config"
TERMUX_PKG_DESCRIPTION="Syncs KDE settings to GTK applications"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kde-gtk-config-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f7e6585265e96da425b9e54b536050a8755f48e82a38a24a837ff762b923723c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gsettings-desktop-schemas, kdecoration, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kguiaddons, kf6-kwindowsystem, libc++, qt6-qtbase, qt6-qtsvg, xsettingsd"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, gtk3, sassc"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"
