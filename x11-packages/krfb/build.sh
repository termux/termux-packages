TERMUX_PKG_HOMEPAGE="https://apps.kde.org/krfb/"
TERMUX_PKG_DESCRIPTION="Desktop Sharing"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/krfb-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=3dd46a3a0e6da3008a11407333453b5e7763057e739025d3525106301ed38c4a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kdnssd, kf6-ki18n, kf6-knotifications, kf6-kstatusnotifieritem, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kpipewire, kwayland, libc++, libvncserver, libwayland, libx11, libxcb, libxtst, qt6-qtbase, xcb-util-image"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, libxdamage, plasma-wayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi

	LDFLAGS+=" -landroid-shmem"
}
