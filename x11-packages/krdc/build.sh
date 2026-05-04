TERMUX_PKG_HOMEPAGE="https://apps.kde.org/krdc/"
TERMUX_PKG_DESCRIPTION="Remote Desktop Client by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/krdc-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=430dc9e821fc0db7730eadd2306d81531015315a0a194fd0cb3ed6dcdff6489d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="keditbookmarks, kf6-kbookmarks, kf6-kcmutils, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdnssd, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-knotifyconfig, kf6-kstatusnotifieritem, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libssh, libwayland, qt6-qtbase, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, freerdp, kf6-kdoctools, libvncserver"
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
