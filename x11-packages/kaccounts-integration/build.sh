TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/kaccounts-integration"
TERMUX_PKG_DESCRIPTION="Online account management system and its Plasma integration components"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kaccounts-integration-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="6f3b3d5b630ad1150425982d1266718075c419580bb0f828824524a380c85aa5"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kwallet, libaccounts-qt, libc++, qt6-qtbase, qt6-qtdeclarative, signon-kwallet-extension, signon-plugin-oauth2, signon-ui, signond"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qcoro, qcoro-static, kf6-kdoctools"
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
