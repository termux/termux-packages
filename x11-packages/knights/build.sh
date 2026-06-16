TERMUX_PKG_HOMEPAGE="https://invent.kde.org/games/knights"
TERMUX_PKG_DESCRIPTION="KNights is a chess game application."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/knights-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=12e468394ce066c473db4475e417665e4a52ae0d19995ffb2c8359417f635801
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdoctools, kf6-ki18n, kf6-kio, kf6-kplotting, kf6-ksvg, kf6-ktextwidgets, kf6-kwallet, kf6-kxmlgui, libkdegames, libc++, libplasma, qt6-qtbase"
TERMUX_PKG_RECOMMENDS="gnuchess, stockfish"
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
