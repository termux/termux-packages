TERMUX_PKG_HOMEPAGE=https://calligra.org/
TERMUX_PKG_DESCRIPTION="Office and graphic art suite by KDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/calligra-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=f29a18bdd96c3d009a8056e9c60110c4d65ced30a71d7cd976e3a0849b40abb0
# it could use qt6-qtwebengine, but that dependency is not available for 32-bit x86 architecture.
TERMUX_PKG_DEPENDS="fontconfig, freetype, gsl, imath, kf6-karchive, kf6-kcmutils, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-kjobwidgets, kf6-knotifications, kf6-knotifyconfig, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-purpose, kf6-solid, kf6-sonnet, kf6-qqc2-desktop-style, kirigami-addons, libc++, libetonyek, libgit2, libodfgen, librevenge, libvisio, libwpd, libwpg, libwps, littlecms, mediainfo, mlt, okular, opengl, openssl, opentimelineio, perl, phonon-qt6, poppler, poppler-qt, qca, qt6-qtbase, qt6-qtdeclarative, qt6-qtmultimedia, qt6-qtnetworkauth, qt6-qtsvg, qtkeychain, shared-mime-info, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, eigen, extra-cmake-modules, kf6-kconfig-cross-tools, kf6-kdoctools, kf6-kdoctools-cross-tools, qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DUSE_DBUS=OFF
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local QT6_HOSTBUILD_COMPILER_ARGS="
	-L$TERMUX_PREFIX/opt/qt6/cross/lib
	-Wl,-rpath=$TERMUX_PREFIX/opt/qt6/cross/lib
	-lQt6Core
	-lQt6Xml
	-I$TERMUX_PREFIX/opt/qt6/cross/include/qt6/QtCore
	-I$TERMUX_PREFIX/opt/qt6/cross/include/qt6/QtXml
	-I$TERMUX_PREFIX/opt/qt6/cross/include/qt6
	"
	g++ "$TERMUX_PKG_SRCDIR/devtools/rng2cpp/rng2cpp.cpp" \
		$QT6_HOSTBUILD_COMPILER_ARGS \
		-o rng2cpp

	g++ "$TERMUX_PKG_SRCDIR/filters/sheets/excel/sidewinder/recordsxml2cpp.cpp" \
		$QT6_HOSTBUILD_COMPILER_ARGS \
		-o recordsxml2cpp
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	fi
}
