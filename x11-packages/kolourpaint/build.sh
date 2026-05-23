TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/kolourpaint"
TERMUX_PKG_DESCRIPTION="Paint Program"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kolourpaint-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="2225d194b2af7498c40a2c68426b8c28dfc0beb83dc5b93de93e50b3e4d76609"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, qt6-qtbase"
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
