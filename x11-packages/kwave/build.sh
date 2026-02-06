TERMUX_PKG_HOMEPAGE="https://apps.kde.org/kwave/"
TERMUX_PKG_DESCRIPTION="A sound editor by KDE"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.12.2"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/release-service/${TERMUX_PKG_VERSION}/src/kwave-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=fe6705daaf214c109f191b45050d8631f311e442fa9926f7b9bf5ace0bdbf4b0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="alsa-lib, audiofile, fftw, flac, id3lib, kf6-karchive, kf6-kcompletion, kf6-kconfig, kf6-kconfigwidgets, kf6-kcoreaddons, kf6-kcrash, kf6-kdbusaddons, kf6-ki18n, kf6-kiconthemes, kf6-kio, kf6-ktextwidgets, kf6-kwidgetsaddons, kf6-kxmlgui, libc++, libmad, libogg, libsamplerate, libvorbis, pulseaudio, qt6-qtbase, qt6-qtmultimedia"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, kf6-kdoctools, libopus, librsvg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DWITH_OSS=OFF
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DKF6_HOST_TOOLING=$TERMUX_PREFIX/opt/kf6/cross/lib/cmake/"
	fi
}
