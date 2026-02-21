TERMUX_PKG_HOMEPAGE=https://shotcut.org/
TERMUX_PKG_DESCRIPTION="Cross-platform Qt based Video Editor"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="26.2.16"
TERMUX_PKG_SRCURL="https://github.com/mltframework/shotcut/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=1fe94436879dd5e10dc97d1d73162cf86edc1cc6a3a0917f3f36875dc9f51854
TERMUX_PKG_DEPENDS="ffmpeg, fftw, frei0r-plugins, mlt, libx264, libvpx, lame, ladspa-sdk, movit, qt6-qtbase, qt6-qtcharts, qt6-qtdeclarative, qt6-qtimageformats, qt6-qtmultimedia, qt6-qttranslations, qt6-qtwebsockets, sdl2 | sdl2-compat"
TERMUX_PKG_BUILD_DEPENDS="qt6-qttools"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"
TERMUX_PKG_AUTO_UPDATE=true
# if CMAKE_SYSTEM_NAME is left as Android,
# will fail to detect Qt6::DBus and fail to compile
# https://github.com/mltframework/shotcut/commit/f0f5f18125d73e55e7f32ff1b106e24558de1cf5
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
"

termux_step_pre_configure(){
	CXXFLAGS+=' -Wno-c++11-narrowing'
}
