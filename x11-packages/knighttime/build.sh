TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/knighttime"
TERMUX_PKG_DESCRIPTION="KDE Helper for scheduling the dark-light cycle"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/knighttime-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=6f328e1e8d6e6e22628f364bf049a535895f08cb565fb1551b75d7de6178e8b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kholidays, libc++, qt6-qtbase, qt6-qtpositioning"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-ki18n, qt6-qttools"
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
