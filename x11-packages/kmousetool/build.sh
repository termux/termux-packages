TERMUX_PKG_HOMEPAGE="https://invent.kde.org/accessibility/kmousetool"
TERMUX_PKG_DESCRIPTION="Clicks the mouse for you, reducing the effects of RSI"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kmousetool-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b13a90eee91a91fb029966f128656f4e46126abf711b614e74080087e06d0fff
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kstatusnotifieritem, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libx11, libxtst, qt6-qtbase, qt6-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, libxt"
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
