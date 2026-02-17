TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-integration"
TERMUX_PKG_DESCRIPTION="Qt Platform Theme integration plugins for the Plasma workspaces"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-integration-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=5a69d012da2cbfc6d4d9177531f1a68c60cb023fbde114d5d5e95637b6189dfb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kjobwidgets, kf6-kservice, kf6-kstatusnotifieritem, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, qqc2-breeze-style, kf6-qqc2-desktop-style, libc++, libwayland, libxcb, libxcursor, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_QT5=OFF
"
termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
