TERMUX_PKG_HOMEPAGE="https://apps.kde.org/ark"
TERMUX_PKG_DESCRIPTION="KDE Archiving Tool"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/ark-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="391fae7a08757dd5cc2b0081251c513859345e49d30ce7f10c3da5f4ce4ba3a0"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="7zip, arj, kf6-breeze-icons, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kfilemetadata, kf6-ki18n, kf6-kio, kf6-kjobwidgets, kf6-kparts, kf6-kpty, kf6-kservice, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, libarchive, libc++, libzip, lrzip, lzop, qt6-qtbase, unrar, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
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
