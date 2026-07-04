TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/minuet"
TERMUX_PKG_DESCRIPTION="A KDE Software for Music Education"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/minuet-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=2fdbc21f80090274181bef800b15e6c3583c535768c1a5a66a9b00417f6462b1
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
