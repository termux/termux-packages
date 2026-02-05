TERMUX_PKG_HOMEPAGE=https://apps.kde.org/gwenview/
TERMUX_PKG_DESCRIPTION="Fast and easy to use image viewer by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/gwenview-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=0e63d7054168e9acf366961582d0f5121e1af6bc58c58b9a22065aa65de683fb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exiv2, kf6-baloo, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kfilemetadata, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kimageformats, kf6-kio, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-kparts, kf6-kservice, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-purpose, kf6-solid, kimageannotator, libc++, libjpeg-turbo, libkdcraw, libpng, libtiff, libwayland, libx11, littlecms, plasma-activities, qt6-qtmultimedia, qt6-qtbase, qt6-qtimageformats, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, libwayland-protocols"
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
