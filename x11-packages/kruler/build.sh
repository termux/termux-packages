TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/kruler"
TERMUX_PKG_DESCRIPTION="Pixel measuring tool by KDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kruler-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=dcf9aaaf349950bd2f8339653c50c05166da74a19bb92de8f2a8e4e27eb2ebfb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gettext, kf6-attica, kf6-kconfig, kf6-kcrash, kf6-ki18n, kf6-knotifications, kf6-kstatusnotifieritem, kf6-kwindowsystem, kf6-kxmlgui, libc++, libx11, littlecms, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="kf6-kconfig-cross-tools, extra-cmake-modules"
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
