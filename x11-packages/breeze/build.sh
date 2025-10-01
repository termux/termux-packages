TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/breeze"
TERMUX_PKG_DESCRIPTION="Artwork, styles and assets for the Breeze visual style for the Plasma Desktop"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/breeze-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="09b3f7bd2386c4b91c418462f02b203510f2ae88489398ef05e0b6ddea3aa590"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-breeze-icons, kf6-frameworkintegration, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kdecoration, kf6-ki18n, kf6-kiconthemes, kf6-kwidgetsaddons, kf6-kpackage, libc++, qt6-qtbase, qt6-qtdeclarative, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kirigami"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_QT6=ON
-DBUILD_QT5=OFF
"
termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
