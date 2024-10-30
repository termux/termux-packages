TERMUX_PKG_HOMEPAGE=https://shotcut.org/
TERMUX_PKG_DESCRIPTION="Cross-platform Qt based Video Editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.10.29"
TERMUX_PKG_SRCURL=https://github.com/mltframework/shotcut/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8635486cfb0e8e0d50e264e97a3ab4c57b2901742b188aed3ee91ac0371b3250
TERMUX_PKG_DEPENDS="ffmpeg, fftw, frei0r-plugins, mlt, libx264, libvpx, lame, ladspa-sdk, movit, qt6-qtbase, qt6-qtcharts, qt6-qtdeclarative, qt6-qtimageformats, qt6-qtmultimedia, qt6-qttranslations, sdl2"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure(){
	CXXFLAGS+=' -Wno-c++11-narrowing'
}
