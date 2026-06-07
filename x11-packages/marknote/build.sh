TERMUX_PKG_HOMEPAGE="https://invent.kde.org/office/marknote"
TERMUX_PKG_DESCRIPTION="A simple markdown note management app"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/marknote/marknote-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="d3bb39614e22fd1a8ddd74bcfb4c384cbffe25685ec01116f694e470816284a9"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kirigami-addons, kf6-breeze-icons, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kirigami, kf6-knotifications, kf6-kwindowsystem, kf6-qqc2-desktop-style, kf6-syntax-highlighting, kmime, libc++, md4c, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
