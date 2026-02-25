TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kscreen"
TERMUX_PKG_DESCRIPTION="KDE's screen management software"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kscreen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=0e8a6b1b3db6ccadf5b22e38b9d0607ab74f9316b10920cdfcd995053e1985db
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
