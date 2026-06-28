TERMUX_PKG_HOMEPAGE="https://invent.kde.org/graphics/glaxnimate"
TERMUX_PKG_DESCRIPTION="Vector animation and motion design application"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="git+https://invent.kde.org/graphics/glaxnimate"
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ffmpeg, hicolor-icon-theme, kf6-karchive, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libarchive, potrace, python, python-pillow, qt6-qtbase, qt6-qtsvg, qt6-qttools"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		LDFLAGS+=" -l:libomp.a"

		termux_setup_build_python

		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DPYBIND11_USE_CROSSCOMPILING=ON"
	fi
}
