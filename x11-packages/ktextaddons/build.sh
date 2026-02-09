TERMUX_PKG_HOMEPAGE="https://invent.kde.org/libraries/ktextaddons"
TERMUX_PKG_DESCRIPTION="Various text handling addons"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/ktextaddons/ktextaddons-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="366d5a94c7405482c3a6d261347c1b995de73a087059996b117d612bfc1291c2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kcolorscheme, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-kservice, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-sonnet, kf6-syntax-highlighting, libc++, qt6-qtbase, qt6-qtspeech, qtkeychain"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qttools"
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
