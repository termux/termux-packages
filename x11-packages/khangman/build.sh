TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/khangman"
TERMUX_PKG_DESCRIPTION="Hangman Game"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/khangman-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=c5be0a733e910682d0d67a6db3236be2cbad42da16c3e7c1a77096ab3d2b81f0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kirigami-addons, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kirigami, kf6-knewstuff, libc++, libkeduvocdocument, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kconfigwidgets, kf6-kdoctools"
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
