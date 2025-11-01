TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/kio-extras"
TERMUX_PKG_DESCRIPTION="Additional components to increase the functionality of KIO"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kio-extras-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="868f9f2e0f572725387ea311f199d2fa044acc03656f3751e7ca26400861375f"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, kf6-karchive, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kdnssd, kf6-ki18n, kf6-kio, kf6-knotifications, kf6-kservice, kf6-kwidgetsaddons, kf6-syntax-highlighting, kf6-solid, libimobiledevice, libc++, libkexiv2, libproxy, libplist, libssh, libtirpc, libxcursor, perl, plasma-activities, qt6-qt5compat, qt6-qtbase, qt6-qtimageformats, qt6-qtsvg, ripgrep-all"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules ,gperf, openexr, plasma-activities-stats, qcoro, taglib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_DOC=OFF
-DBUILD_WITH_QT6=ON
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi

	LDFLAGS+=" -landroid-shmem"
}
