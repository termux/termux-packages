TERMUX_PKG_HOMEPAGE="https://invent.kde.org/games/kmines"
TERMUX_PKG_DESCRIPTION="KMines is a classic Minesweeper game."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmines-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c0111c0e055e3e88853be80ee6d3f624d3a3a1d7efe04810280632e02e0fd030
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kiconthemes, kf6-ki18n, kf6-kwidgetsaddons, kf6-ktextwidgets, kf6-kxmlgui, libkdegames, libc++, qt6-qtbase"
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
