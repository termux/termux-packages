TERMUX_PKG_HOMEPAGE=https://www.audacityteam.org/
TERMUX_PKG_DESCRIPTION="An easy-to-use, multi-track audio editor and recorder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.0.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/audacity/audacity/releases/download/Audacity-${TERMUX_PKG_VERSION}/audacity-sources-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6cf1230a1aa940a9188476737d342100c5de6480a476f253fc844bd031d7e6f4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+(?!-)"
TERMUX_PKG_DEPENDS="ffmpeg, freetype, glib, harfbuzz, libc++, libexpat, libflac, libmp3lame, libogg, libopus, libpng, libpugixml, libsndfile, libsoundtouch, libsoxr, libsqlite, libtwolame, libuuid, libvorbis, libwavpack, libmpg123, opusfile, portaudio, portmidi, qt6-qt5compat, qt6-qtbase, qt6-qtdeclarative, qt6-qtnetworkauth, qt6-qtshadertools, qt6-qtsvg, wxwidgets, zlib"
TERMUX_PKG_BUILD_DEPENDS="rapidjson, utf8cpp, qt6-qtbase-cross-tools, qt6-qtdeclarative-cross-tools, qt6-qtshadertools-cross-tools, qt6-qttools, qt6-qttools-cross-tools"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DAU4_BUILD_MODE=release
-DAU_BUILD_CLOUD_AUDIOCOM=OFF
-DAU_BUILD_USAGEINFO_MODULE=OFF
-DAU_MODULE_EFFECTS_LV2=OFF
-DAU_MODULE_EFFECTS_VST=OFF
-DAU_USE_LIBCURL=OFF
-DEXTDEPS_OVERRIDE_SBSMS=REBUILD
-DMUSE_ENABLE_UNIT_TESTS=OFF
-DMUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT=OFF
-DMUSE_COMPILE_USE_CCACHE=OFF
-DMUSE_COMPILE_USE_UNITY=OFF
-DEXTDEPS_OVERRIDE_ALL=SYSTEM
-DWX_CONFIG=$TERMUX_PREFIX/bin/wx-config
"

termux_step_post_get_source() {
	find "$TERMUX_PKG_SRCDIR" -name "._*" -delete

	local nyquist_recipe="$TERMUX_PKG_SRCDIR/muse_deps/recipes/nyquist"
	cp "$TERMUX_PKG_BUILDER_DIR/nyquist-android-no-timeb.diff" \
		"$nyquist_recipe/patch/0031-termux-android-no-timeb.patch"
	sed -i '/0030-d881c57712-rename-swap-functions/a\    "patch/0031-termux-android-no-timeb.patch"' \
		"$nyquist_recipe/spec.cmake"
}

termux_step_pre_configure() {
	CPPFLAGS+=" -Dushort=u_short -Dulong=u_long -D_FILE_OFFSET_BITS=64"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/audacity"
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo
		echo "********"
		echo "Audacity can not use microphone until you grant microphone access to Termux:API."
		echo "********"
		echo
	EOF
}
