TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/kimagemapeditor"
TERMUX_PKG_DESCRIPTION="HTML Image Map Editor"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kimagemapeditor-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="861d233710e333b86310016a2d5e06bdc77e435874daa0229dc3223009863ad8"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kparts, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, qt6-qtbase, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
