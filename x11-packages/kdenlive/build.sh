TERMUX_PKG_HOMEPAGE='https://apps.kde.org/kdenlive/'
TERMUX_PKG_DESCRIPTION='A non-linear video editor for Linux using the MLT video framework'
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdenlive-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5a1f2c159734a72ec8bf9330832c25175a7f037b1b1d1c7b7fab960250bf8154
TERMUX_PKG_DEPENDS="libc++, ffplay, frei0r-plugins, kddockwidgets, kf6-karchive, kf6-kbookmarks, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kfilemetadata, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-knewstuff, kf6-knotifications, kf6-knotifyconfig, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-purpose, kf6-qqc2-desktop-style, kf6-solid, mediainfo, mlt, opentimelineio, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtnetworkauth, qt6-qtsvg, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, imath, qt6-qttools, kf6-kconfig-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DFETCH_OTIO=OFF
-DUSE_DBUS=OFF
"
# FIXME: -DUSE_DBUS=OFF is needed because there seems to be an issue related to qdbus and kf6-kjobwidgets causing kdenlive video rendering stuck at "WAITING"

termux_step_pre_configure() {
	# Prevent ERROR: MIME cache found in package. Please disable `update-mime-database`
	sed -e 's|update_xdg_mimetypes(|# update_xdg_mimetypes(|' -i data/CMakeLists.txt

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
