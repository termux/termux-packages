TERMUX_PKG_HOMEPAGE=https://shotcut.org/
TERMUX_PKG_DESCRIPTION="Cross-platform Qt based Video Editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="24.11.17"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/mltframework/shotcut/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=cb6a3a819b3ae56325406665273347328ae973250c02a832fce609ee6c0f6b13
TERMUX_PKG_DEPENDS="ffmpeg, fftw, frei0r-plugins, mlt, libx264, libvpx, lame, ladspa-sdk, movit, qt6-qtbase, qt6-qtcharts, qt6-qtdeclarative, qt6-qtimageformats, qt6-qtmultimedia, qt6-qttranslations, sdl2 | sdl2-compat"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure(){
	CXXFLAGS+=' -Wno-c++11-narrowing'
}
