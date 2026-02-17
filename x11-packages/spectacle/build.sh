TERMUX_PKG_HOMEPAGE="https://apps.kde.org/spectacle/"
TERMUX_PKG_DESCRIPTION="KDE screenshot capture utility"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/spectacle-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=aa14a7fdaa0c44311f0c41f3502af39374c65057c515b779682d5dbd94fcbfe3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.[0-8].*"
TERMUX_PKG_DEPENDS="libc++, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kglobalaccel, kf6-kguiaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kjobwidgets, kf6-knotifications, kpipewire, kf6-kservice, kf6-kstatusnotifieritem, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, layer-shell-qt, libxcb, opencv (< 5), kf6-prison, kf6-purpose, kquickimageeditor, qt6-qtbase, qt6-qtdeclarative, qt6-qtimageformats, qt6-qtmultimedia, libwayland, xcb-util, xcb-util-cursor, xcb-util-image"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, plasma-wayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DCMAKE_CXX_FLAGS=-I$TERMUX_PREFIX/include/opencv4
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
