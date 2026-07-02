TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/analitza"
TERMUX_PKG_DESCRIPTION="A library to add mathematical features to your program"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/analitza-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=615b7c244a5baee0be5214c53b8ce37d0a54e69a6fd6b8438c30d7fda45b0746
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="eigen, extra-cmake-modules, kf6-kdoctools, qt6-qttools"
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
