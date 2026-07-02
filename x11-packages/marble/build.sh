TERMUX_PKG_HOMEPAGE="https://invent.kde.org/education/marble"
TERMUX_PKG_DESCRIPTION="Desktop Globe"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/marble-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=75242b4019b2e873ab82d0e5d0149236779f4e9931782bf0cd5c6b67bcb69208
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="abseil-cpp, kf6-kcmutils, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kparts, kf6-kwidgetsaddons, kf6-kxmlgui, kirigami-addons, libc++, libplasma, phonon-qt6, protobuf, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtpositioning, qt6-qtsvg, qt6-qtwebchannel, qt6-qtwebengine, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, kf6-knewstuff, kf6-krunner, qt6-qttools, qt6-qttools-cross-tools"
#qt6-qtwebengine is not supported for i686 architecture
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_setup_protobuf

		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DQt6LinguistTools_DIR=$TERMUX_PREFIX/opt/qt6/cross/lib/cmake/Qt6LinguistTools"
	fi
}
