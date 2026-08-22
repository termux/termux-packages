TERMUX_PKG_HOMEPAGE="https://invent.kde.org/pim/libksieve"
TERMUX_PKG_DESCRIPTION="KDE PIM library for managing sieves"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.08.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/libksieve-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=51cd71b65a7b1a4f39a2ce05cf44733df5f3bec03aadc0e5846b7b736d2b967f
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
