TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kquickimageeditor"
TERMUX_PKG_DESCRIPTION="QML image editing components"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.0.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/kquickimageeditor/kquickimageeditor-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b65f32c44bd126cea5e1b5a6eb7cb0eb517277cb8de06675fa6be624b7da381a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="highway, kf6-kconfig, kf6-kirigami, libc++, qt6-qtbase, qt6-qtdeclarative"
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
