TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/oxygen"
TERMUX_PKG_DESCRIPTION="KDE Oxygen style"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/oxygen-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=7bbf7b9cab9f2d325382b777d1bd81a153407c74df1610a23e91b4aa0caf15a3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-frameworkintegration, kf6-kcmutils, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kdecoration, kf6-kguiaddons, kf6-ki18n, kf6-kwidgetsaddons, kf6-kwindowsystem, libc++, libxcb, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kirigami, libplasma"
TERMUX_PKG_RECOMMENDS="oxygen-icons"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_QT5=OFF
-DBUILD_QT6=ON
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
