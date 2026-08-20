TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/khangman"
TERMUX_PKG_DESCRIPTION="Hangman Game"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/khangman-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=258d96e4fdd3f9654ef351d1ae853eb79d210e2d006d4cd882a27b3cae6d42f8
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
