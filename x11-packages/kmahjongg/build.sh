TERMUX_PKG_HOMEPAGE="https://invent.kde.org/games/kmahjongg"
TERMUX_PKG_DESCRIPTION="KMahjongg is a tile matching game for one or two players"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmahjongg-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d6c063da23f5e5b6f34b81e0c3bdc52a430f7332becffa4eb1aa51e58e8740da
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libkmahjongg, libkdegames, kf6-kxmlgui, kf6-kdbusaddons, kf6-kcrash, kf6-kconfig, kf6-ki18n, kf6-kwidgetsaddons, kf6-kconfigwidgets, kf6-kcoreaddons, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="kf6-kconfig-cross-tools, extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
