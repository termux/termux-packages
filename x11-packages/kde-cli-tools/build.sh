TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/kde-cli-tools"
TERMUX_PKG_DESCRIPTION="Tools based on KDE Frameworks to better interact with the system"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/kde-cli-tools-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="74661d8dc71a345b90651775980b0ad3afb288194af06aa33abc698e0183e2c3"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash, kf6-kcmutils, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kio, kf6-kparts, kf6-kservice, kf6-kwidgetsaddons, kf6-kwindowsystem, libc++, qt6-qtbase, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_DOC=OFF
"
termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
