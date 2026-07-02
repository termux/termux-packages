TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/kig"
TERMUX_PKG_DESCRIPTION="Interactive Geometry"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kig-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=e357e5e890bd95a1a44d0d5be8ba8eec8745e018dd4e5291f778b962d1f15ee0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="boost, kf6-karchive, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kparts, kf6-ktexteditor, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, python, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, extra-cmake-modules, kf6-kdoctools"
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
