TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-desktop"
TERMUX_PKG_DESCRIPTION="KDE Plasma Desktop"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-desktop-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="2367f12531575b2e445cd2b0fa0b756f151f10eaa27358b0966735ff400146c7"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, ibus, kf6-attica, kf6-baloo, kf6-kauth, kf6-kbookmarks, kf6-kcmutils, kf6-kcodecs, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdeclarative, kf6-kglobalaccel, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-knewstuff, kf6-knotifications, kf6-knotifyconfig, kf6-kpackage, kf6-krunner, kf6-kservice, kf6-ksvg, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-solid, kf6-sonnet, kirigami-addons, kmenuedit, kscreen, libc++, libcanberra, libksysguard, libplasma, libwayland, libx11, libxcb, libxcursor, libxi, libxkbcommon, libxkbfile, plasma-activities, plasma-activities-stats, plasma-pa, plasma-workspace, plasma5support, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, sdl2, xcb-util-keysyms"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, ibus, intltool, kf6-kdoctools, libwayland-protocols, xorg-server"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_KCM_MOUSE_X11=OFF
-DBUILD_KCM_TOUCHPAD_X11=OFF
-DBUILD_DOC=OFF
-DBUILD_KCM_TOUCHPAD_KWIN_WAYLAND=OFF
-DBUILD_KCM_MOUSE_KWIN_WAYLAND=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
