TERMUX_PKG_HOMEPAGE=https://calligra.org/components/plan/
TERMUX_PKG_DESCRIPTION="Visual database applications creator"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.1"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/calligraplan/calligraplan-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=9267ea174c04466014343927f73757bb3047dab36a74fc8f38b891e8d8833a39
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="libc++, kdiagram, kf6-kcalendarcore, kf6-karchive, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kdbusaddons, kf6-kholidays, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemmodels, kf6-kitemviews, kf6-kjobwidgets, kf6-knotifications, kf6-kparts, kf6-kservice, kf6-ktextwidgets, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, plasma-activities, qt6-qtbase"
TERMUX_PKG_BUILD_DEPENDS="kf6-kdoctools, kf6-kdoctools-cross-tools, extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
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
		-o plan_rng2cpp
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake"
		export PATH="$TERMUX_PKG_HOSTBUILD_DIR:$PATH"
	fi
}
