TERMUX_PKG_HOMEPAGE="https://invent.kde.org/network/ktorrent"
TERMUX_PKG_DESCRIPTION="A powerful BitTorrent client for KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/ktorrent-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="3b534a58facb1a259a87275aa8ec312957cd886ffcc23fd4ac08e022e87c51ae"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcmutils, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-knotifications, kf6-knotifyconfig, kf6-kparts, kf6-kstatusnotifieritem, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, libc++, libktorrent, libmaxminddb, phonon-qt6, qt6-qt5compat, qt6-qtbase, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules, kf6-kdnssd, kf6-kdoctools, kf6-kplotting, kf6-syndication, taglib"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
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
