TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/kquickimageeditor"
TERMUX_PKG_DESCRIPTION="QML image editing components"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/kquickimageeditor/kquickimageeditor-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b868800bb9bb814ee36c9d696be9ccec9a22ab6f975d789e248b75fbd1ba99fa
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kirigami, libc++, opencv, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_CXX_FLAGS=-I$TERMUX_PREFIX/include/opencv4
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
