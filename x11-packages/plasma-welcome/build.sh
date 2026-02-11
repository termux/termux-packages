TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-welcome"
TERMUX_PKG_DESCRIPTION="A friendly onboarding wizard for Plasma"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-welcome-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="32e29caa3507047f786857a0dd10830835837a0b5bb1d67d4b7f4e5540e00920"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kjobwidgets, kf6-knewstuff, kf6-kservice, kf6-ksvg, kf6-kuserfeedback, kf6-kwindowsystem, kirigami-addons, libc++, libplasma, plasma5support, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
