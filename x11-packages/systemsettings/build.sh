TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/systemsettings"
TERMUX_PKG_DESCRIPTION="KDE system manager for hardware, software, and workspaces"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.5.5"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/systemsettings-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256="8677fe07e66bad787e7ef43e935296c201973a4ec9505ba00d6f3afe4b1cc2c6"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kauth, kf6-kcmutils, kf6-kcolorscheme, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kio, kf6-kirigami, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-krunner, kf6-kservice, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, libc++, plasma-activities, qt6-qtbase, qt6-qtdeclarative"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, ibus, intltool, kf6-kdoctools, libwayland-protocols"
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
