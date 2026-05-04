TERMUX_PKG_HOMEPAGE="https://apps.kde.org/audiotube/"
TERMUX_PKG_DESCRIPTION="AudioTube can search YouTube Music, list albums and artists, play automatically generated playlists, albums and allows to put your own playlist together"
TERMUX_PKG_LICENSE="GPL-2.0-or-later, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.04.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/audiotube-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=ed44c45dfdb47978ef88d99a4dc68e65fe194cb1d33bda9a7b68717862e2eca8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="futuresql, gst-plugins-bad, gst-plugins-good, gst-plugins-ugly, kf6-kconfig, kf6-kcoreaddons, kf6-kcrash, kf6-ki18n, kf6-kiconthemes, kf6-kirigami, kf6-kwindowsystem, kf6-purpose, kirigami-addons, libc++, python, python-pip, qt6-qtbase, qt6-qtdeclarative, qt6-qtimageformats, qt6-qtmultimedia, qt6-qtsvg, python-yt-dlp"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, pybind11, qcoro, qcoro-static"
TERMUX_PKG_PYTHON_COMMON_BUILD_DEPS="ytmusicapi"
TERMUX_PKG_PYTHON_TARGET_DEPS="ytmusicapi"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
-DBUILD_WITH_QT6=ON
-DPYBIND11_USE_CROSSCOMPILING=ON
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
