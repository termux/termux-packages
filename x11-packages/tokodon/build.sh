TERMUX_PKG_HOMEPAGE="https://apps.kde.org/tokodon/"
TERMUX_PKG_DESCRIPTION="A Mastodon client for Plasma"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/tokodon-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f5197e65c8d7969f93deca601ac3d84493de22d3d2440bd50c5193af22defb28
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kdeclarative, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-knotifications, kf6-kservice, kf6-kwindowsystem, kf6-prison, kf6-purpose, kf6-qqc2-desktop-style, kirigami-addons, kunifiedpush, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtwebsockets, qt6-qtwebview, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qcoro, qcoro-static"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
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
