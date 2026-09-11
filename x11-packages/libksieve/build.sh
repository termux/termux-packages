TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/libksieve"
TERMUX_PKG_DESCRIPTION="KDE PIM library for managing sieves"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libksieve-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=6e9629c4aae301fb2cfd8d5c383c647bb33a04d0e983dcd4fae8964d5ad67ed6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kcoreaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kwidgetsaddons, kf6-sonnet, kf6-syntax-highlighting, kidentitymanagement, kf6-kmime, ktextaddons, libc++, libkdepim, libsasl, pimcommon, qt6-qtbase, qt6-qtwebengine"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, kmailtransport"
# qt6-qtwebengine is not supported on the i686 architecture
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
