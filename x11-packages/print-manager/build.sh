TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/print-manager"
TERMUX_PKG_DESCRIPTION=" A tool for managing print jobs and printers"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/print-manager-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9b45069d8e61bfa5d2cf958fd562d18fe0dccb677008d99aceeb5599b808b5ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="cups, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-knotifications, kf6-kwidgetsaddons, kf6-kwindowsystem, libc++, libplasma, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
