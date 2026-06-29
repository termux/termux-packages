TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/kanagram"
TERMUX_PKG_DESCRIPTION="Letter Order Game"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kanagram-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="73a1d5056fd00f137bac234cb618d24a8f3e4bda31d03fec0089bb93de069ab9"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-knewstuff, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-sonnet, libc++, libkeduvocdocument, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtspeech"
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
