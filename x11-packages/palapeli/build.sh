TERMUX_PKG_HOMEPAGE="https://invent.kde.org/games/palapeli"
TERMUX_PKG_DESCRIPTION="Palapeli is a single-player jigsaw puzzle game."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/palapeli-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=4e6d678cf8dd3866c829ae006d01bd07f2e045c03f5677227d2e20fd7b86ad05
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdoctools, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-knewstuff, kf6-kwidgetsaddons, kf6-ktextwidgets, kf6-kxmlgui, libkdegames, libc++, qt6-qtbase"
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
