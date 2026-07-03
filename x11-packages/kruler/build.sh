TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/kruler"
TERMUX_PKG_DESCRIPTION="Pixel measuring tool by KDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="3ls-it <3ls-it@pm.me>"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kruler-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=634b154d05db526a4d05025e7358b01929b7c5938602477f6880b19c6ba79a13
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
