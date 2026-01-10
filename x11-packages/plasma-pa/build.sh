TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/plasma-pa"
TERMUX_PKG_DESCRIPTION="Plasma applet for audio volume management using PulseAudio"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/plasma-pa-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="627e90c160669840d29f0ffa83f525e1ec69e306dff3dc35c1db282527b1a587"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, kf6-kcmutils, kf6-kconfig, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kdeclarative, kf6-kglobalaccel, kf6-ki18n, kf6-kirigami, kf6-kitemmodels, kf6-kstatusnotifieritem, kf6-ksvg, libc++, libcanberra, libplasma, plasma-workspace, pulseaudio, pulseaudio-qt, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
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
}
