TERMUX_PKG_HOMEPAGE='https://apps.kde.org/kdenlive/'
TERMUX_PKG_DESCRIPTION='A non-linear video editor for Linux using the MLT video framework'
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.12.2"
TERMUX_PKG_SRCURL=https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kdenlive-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=37be18de3583fda33fb246f312f5a4e25c1e64ae6d746668244252e2033ef489
TERMUX_PKG_DEPENDS="libc++, ffplay, frei0r-plugins, kf6-karchive, kf6-kbookmarks, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kfilemetadata, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-knewstuff, kf6-knotifications, kf6-knotifyconfig, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, kf6-purpose, kf6-qqc2-desktop-style, kf6-solid, mediainfo, mlt, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtnetworkauth, qt6-qtsvg, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools, kf6-kconfig-cross-tools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/
-DUSE_DBUS=OFF
"
# FIXME: -DUSE_DBUS=OFF is needed because there seems to be an issue related to qdbus and kf6-kjobwidgets causing kdenlive video rendering stuck at "WAITING"

termux_step_pre_configure() {
	# Prevent ERROR: MIME cache found in package. Please disable `update-mime-database`
	sed -e 's|update_xdg_mimetypes(|# update_xdg_mimetypes(|' -i data/CMakeLists.txt
}
