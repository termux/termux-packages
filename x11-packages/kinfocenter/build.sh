TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kinfocenter"
TERMUX_PKG_DESCRIPTION="A utility that provides information about a computer system"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kinfocenter-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="567b8f9f4c806414cf417fd59aceaa37485696bd6b655aea01fffd6e2bd5b81c"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="aha, clinfo, glu, iproute2, kf6-kauth, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdeclarative, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kservice, kf6-solid, libc++, libdisplay-info, libdrm, libwayland, mesa-demos, pulseaudio, qt6-qtbase, qt6-qtdeclarative, systemsettings, vulkan-tools, xorg-xdpyinfo"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, vulkan-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DBUILD_DOC=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi

	# for some reason repeated builds will fail to reinstall the executable if it is already present
	rm -f "$TERMUX_PREFIX/bin/kinfocenter"
}
