TERMUX_PKG_HOMEPAGE=https://obsproject.com
TERMUX_PKG_DESCRIPTION="Free and open source software for live streaming and screen recording"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_API_LEVEL=26
TERMUX_PKG_VERSION=(
	"32.2.2"
	"5.7.3"
)
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=(
	"https://github.com/obsproject/obs-studio/archive/refs/tags/${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/obsproject/obs-websocket/archive/refs/tags/${TERMUX_PKG_VERSION[1]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	35d3cd0979d65664fada7119fdb612eca7c34b61a1623a330caec74bf72626c4
	5e9f06aae32a8ac0f94886e8caa5947ad7da41670169c9ee1a08e28cf53c65f5
)
TERMUX_PKG_DEPENDS="ffmpeg, fontconfig, freetype, glib, libandroid-glob, libandroid-spawn, libcurl, libdatachannel, libjansson, librnnoise, libuuid, libx11, libx264, libxcb, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxkbcommon, libxrandr, libxrender, mbedtls, mesa, pulseaudio, qrcodegen, qt6-qtbase, qt6-qtsvg, vulkan-loader, zlib"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, librnnoise, nlohmann-json, pkg-config, python, simde, speexdsp, swig, uthash, vlc-qt, websocketpp"
TERMUX_PKG_SUGGESTS="libfdk-aac, librnnoise, luajit, python, speexdsp, vlc-qt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DOBS_VERSION_OVERRIDE=${TERMUX_PKG_VERSION[0]}
-DENABLE_BROWSER=OFF
-DENABLE_AJA=OFF
-DENABLE_DECKLINK=OFF
-DENABLE_JACK=OFF
-DENABLE_SNDIO=OFF
-DENABLE_V4L2=OFF
-DENABLE_VST=OFF
-DENABLE_ALSA=OFF
-DENABLE_PIPEWIRE=OFF
-DENABLE_WAYLAND=ON
-DENABLE_UI=ON
-DENABLE_WEBRTC=ON
-DENABLE_WEBSOCKET=ON
-DENABLE_LIBFDK=ON
-DENABLE_RNNOISE=ON
-DENABLE_SCRIPTING_PYTHON=OFF
-DENABLE_FREETYPE=ON
-DENABLE_NEW_MPEGTS_OUTPUT=OFF
-DENABLE_FFMPEG_NVENC=OFF
-DENABLE_TEST_INPUT=OFF
-DENABLE_RELOCATABLE=OFF
-DENABLE_PORTABLE_CONFIG=OFF
-DOBS_COMPILE_DEPRECATION_AS_WARNING=OFF
-DCMAKE_INSTALL_BINDIR=bin
-DCMAKE_INSTALL_LIBDIR=lib
-DCMAKE_INSTALL_INCLUDEDIR=include
-DCMAKE_INSTALL_DATAROOTDIR=share
-DCMAKE_PLATFORM_NO_VERSIONED_SONAME=OFF
-Dqrcodegencpp_DIR=$TERMUX_PREFIX/lib/cmake/qrcodegencpp
-Dwebsocketpp_DIR=$TERMUX_PREFIX/lib/cmake/websocketpp
-DUUID_INCLUDE_DIR=$TERMUX_PREFIX/include
-DUUID_LIBRARY=$TERMUX_PREFIX/lib/libuuid.so
"

termux_step_post_get_source() {
	# Remove the empty placeholder folders
	rm -rf plugins/obs-websocket

	# Move the extracted GitHub folders into their respective locations
	mv "obs-websocket-${TERMUX_PKG_VERSION[1]}" plugins/obs-websocket
}

termux_step_pre_configure() {
	export LDFLAGS+=" -lm -landroid-glob -landroid-spawn"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	set -e

	REL="\$(getprop ro.build.version.release 2>/dev/null)"
	SDK="\$(getprop ro.build.version.sdk 2>/dev/null)"

	if [ "\$SDK" = "24" ] || [ "\$SDK" = "25" ] || [ "\${REL%%.*}" = "7" ]; then
		printf "\033[1;33m[!] WARNING: obs-studio is not supported on Android 7 and may not run properly.\033[0m\n"
	fi

	exit 0
	EOF
}
