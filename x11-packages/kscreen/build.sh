TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kscreen"
TERMUX_PKG_DESCRIPTION="KDE's screen management software"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kscreen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=0152de1358f64475525e6c0e854fa8b6ecf9e7c5e9a3094610156a52482c2c43
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kimageformats, kf6-kirigami, kf6-kitemmodels, kf6-ksvg, kf6-kwindowsystem, libc++, libwayland, layer-shell-qt, libkscreen, libplasma, libx11, libxcb, libxi, plasma5support, qt6-qtbase, qt6-qtdeclarative, qt6-qtsensors"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, libwayland-protocols"
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
