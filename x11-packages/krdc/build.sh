TERMUX_PKG_HOMEPAGE="https://apps.kde.org/krdc/"
TERMUX_PKG_DESCRIPTION="Remote Desktop Client by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/krdc-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="522596f8e6788a72056e6627088b4a3df1c586e59c98a41a3b7e46f7c0644c19"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="keditbookmarks, kf6-kbookmarks, kf6-kcmutils, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdnssd, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-knotifyconfig, kf6-kstatusnotifieritem, kf6-kwallet, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libssh, libwayland, qt6-qtbase"
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
