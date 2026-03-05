TERMUX_PKG_HOMEPAGE="https://apps.kde.org/kget/"
TERMUX_PKG_DESCRIPTION="Download Manager by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kget-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=a82873a7dffc52825c12c043e93b3be1326176c276e98c735d5831ff8ea1b0bb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gpgmepp, kf6-kcmutils, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-knotifications, kf6-knotifyconfig, kf6-kstatusnotifieritem, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, libc++, qgpgme, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="boost, extra-cmake-modules, kf6-kdoctools, libktorrent"
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
