TERMUX_PKG_HOMEPAGE="https://invent.kde.org/games/libkdegames"
TERMUX_PKG_DESCRIPTION="Common code and data for many KDE games"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libkdegames-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fb9a2199c1d7d5ad827584edb063dd96e41aa8a937980d641e1ffa122d1eccc3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-knewstuff, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libsndfile, openal-soft, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="kf6-kdnssd, kf6-kconfig-cross-tools, extra-cmake-modules"
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
