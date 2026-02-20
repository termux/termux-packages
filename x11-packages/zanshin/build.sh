TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/zanshin"
TERMUX_PKG_DESCRIPTION="To-do management application based on Akonadi"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/zanshin-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="0eed6b4526b4fde5a42612740826c3ea4e53b1c1e8b13b1ee8cdb435dc5f8aa3"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="akonadi, kdepim-runtime, kf6-kcalendarcore, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kitemmodels, kf6-kparts, kf6-krunner, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kontactinterface, libc++, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules, kf6-kdoctools"
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
