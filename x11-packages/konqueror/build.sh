TERMUX_PKG_HOMEPAGE="https://apps.kde.org/konqueror/"
TERMUX_PKG_DESCRIPTION="KDE File Manager & Web Browser"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.3"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/konqueror-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=8f383beada857b522a59b9259ae1f1f83554c5d25d3c39a39fb6f172ec0f889d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_DEPENDS="kf6-karchive, kf6-kbookmarks, kf6-kcmutils, kf6-kcodecs, kf6-kcolorscheme, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-kguiaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-kitemviews, kf6-kjobwidgets, kf6-kparts, kf6-kservice, kf6-ktextwidgets, kf6-kwallet, kf6-kwidgetsaddons, kf6-kwindowsystem, kf6-kxmlgui, kf6-solid, kf6-sonnet, libc++, plasma-activities, qt6-qtbase, qt6-qtwebengine, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools"
TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		termux_download_ubuntu_packages hunspell hunspell-en-us libhunspell-1.7-0
	fi
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export LD_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/lib/x86_64-linux-gnu"

		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" \
			-DHunspell_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr/bin/hunspell \
			-DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
