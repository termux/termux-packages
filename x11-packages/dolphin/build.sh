TERMUX_PKG_HOMEPAGE="https://invent.kde.org/system/dolphin"
TERMUX_PKG_DESCRIPTION="KDE File Manager"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.08.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/dolphin-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="06f4f1698f6407fd34b8c9b2103d91a21ccab6467485bb5fa23e23736ea66791"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="baloo-widgets, filelight, kde-cli-tools, kio-extras, konsole, kf6-baloo, kf6-kbookmarks, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kjobwidgets, kf6-knewstuff, kf6-knotifications, kf6-kparts, kf6-purpose, kf6-kservice, kf6-solid, kf6-ktextwidgets, kf6-kuserfeedback, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, libc++, qt6-qtbase, qt6-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
