TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/powerdevil"
TERMUX_PKG_DESCRIPTION="Manages the power consumption settings of a Plasma Shell"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/powerdevil-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6d0858a84f783c311447f487078969f9b6500973391212eaff4e6cc0fec99ca0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, plasma-activities, kf6-kauth, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-ki18n, kf6-kidletime, kf6-kirigami, kf6-kitemmodels, kf6-knotifications, kf6-kservice, kf6-kxmlgui, kinfocenter, libkscreen, libplasma, libxcb, plasma-workspace, qcoro, qt6-qtbase, qt6-qtdeclarative, kf6-solid, libwayland"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, kf6-kdoctools-cross-tools, plasma-wayland-protocols"
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
