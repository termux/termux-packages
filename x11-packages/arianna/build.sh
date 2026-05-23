TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/arianna"
TERMUX_PKG_DESCRIPTION="EPub Reader for mobile devices"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/arianna-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="9b62f36f0b51205116e64accdee6f13ea03d00bf5bea353f1f5e34ef7079bf96"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kirigami-addons, kf6-baloo, kf6-karchive, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kirigami, kf6-kitemmodels, kf6-kquickcharts, kf6-kwindowsystem, kf6-qqc2-desktop-style, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qthttpserver, qt6-qtwebchannel, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
