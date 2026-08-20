TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/step"
TERMUX_PKG_DESCRIPTION="Interactive Physical Simulator"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/step-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=d89061b66d52574cd2ad254be3bfe5924ef8ae8c6dc1a380766f9e1f79ace516
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gsl, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-knewstuff, kf6-kplotting, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, qalculate-gtk, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="eigen, extra-cmake-modules, kf6-kdoctools"
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
