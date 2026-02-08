TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/milou"
TERMUX_PKG_DESCRIPTION="A dedicated search application built on top of Baloo"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/milou-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="e81d099a02d9fb4800d997338fc8428d88c8b21070e24a8d36dc1d0a123d89dd"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kirigami, kf6-krunner, libc++, libplasma, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
