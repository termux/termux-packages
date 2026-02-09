TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/libkleo"
TERMUX_PKG_DESCRIPTION="KDE PIM cryptographic library"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libkleo-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="c5816b9c46dc46e3f11a805c7a9508db2c33ad0fbf98d7e8fe681eb9bd8f84f6"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gpgmepp, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kitemmodels, kf6-kwidgetsaddons, libc++, qgpgme, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules"
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
