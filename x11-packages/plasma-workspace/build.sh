TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-workspace"
TERMUX_PKG_DESCRIPTION="KDE Plasma Workspace"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-workspace-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=098e1fddb30600855248bea36e012c0f5ff12d1ba3381a1ce42005e4d2304d6e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, freetype, kactivitymanagerd, kde-cli-tools, kf6-kauth, kf6-kbookmarks, kf6-kcmutils, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdeclarative, kf6-kded, kf6-kglobalaccel, kf6-kguiaddons, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kidletime, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-kjobwidgets, kf6-knewstuff, kf6-knotifications, kf6-kpackage, kf6-kparts, kf6-kquickcharts, kf6-krunner, kf6-kservice, kf6-kstatusnotifieritem, kf6-ksvg, kf6-ktexteditor, kf6-ktextwidgets, kf6-kuserfeedback, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-prison, kf6-solid, kio-extras, kirigami-addons, knighttime, kpipewire, kwin-x11, kwayland, layer-shell-qt, libc++, libcanberra, libice, libicu, libkexiv2, libkscreen, libksysguard, libplasma, libsm, libwayland, libx11, libxau, libxcb, libxcursor, libxfixes, libxft, libxtst, milou, ocean-sound-theme, plasma-activities, plasma-activities-stats, plasma-integration, qalculate-gtk, qt6-qtbase, qt6-qtdeclarative, qt6-qtlocation, qt6-qtpositioning, qt6-qtsvg, qt6-qttools, qt6-qtvirtualkeyboard, xcb-util, xcb-util-cursor, xcb-util-image, xorg-xmessage, xorg-xrdb, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-baloo, kf6-kdoctools, plasma-wayland-protocols, qcoro"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
