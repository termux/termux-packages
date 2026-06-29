TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/minuet"
TERMUX_PKG_DESCRIPTION="A KDE Software for Music Education"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/minuet-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="d870e4a36d748d603268d6aab90f2e0005beb743b8d3cfd7a93ccd65e2682dee"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fluidsynth, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kirigami, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg"
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
