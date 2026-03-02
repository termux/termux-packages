TERMUX_PKG_HOMEPAGE=https://tenacityaudio.org/
TERMUX_PKG_DESCRIPTION="An easy-to-use, privacy-friendly, FLOSS, cross-platform multi-track audio editor (Audacity fork)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@3ls-it"
TERMUX_PKG_VERSION="1.3.4"
TERMUX_PKG_SRCURL=git+https://codeberg.org/tenacityteam/tenacity
TERMUX_PKG_GIT_BRANCH="v${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="ffmpeg, gdk-pixbuf, glib, gtk3, libc++, vamp-plugin-sdk, libexpat, libflac, libid3tag, libogg, libopus, libsndfile, libsoundtouch, libsoxr, libuuid, libvorbis, libwavpack, libmpg123, opusfile, portaudio, portmidi, wxwidgets"
TERMUX_PKG_BUILD_DEPENDS="libjpeg-turbo, libjpeg-turbo-static, libmp3lame, libpng, patchelf, rapidjson, zlib"
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_STRIP=llvm-strip
-DVCPKG=Off
-DUSE_MIDI=OFF
"

termux_step_post_get_source() {
		# Sanity check just in case of upstream changes
		[ -d "$TERMUX_PKG_SRCDIR/libraries/lib-ffmpeg-support" ] || \
				termux_error_exit "Expected libraries/lib-ffmpeg-support/ not found"

		cp -a "$TERMUX_PKG_BUILDER_DIR/ffmpeg8/." \
				"$TERMUX_PKG_SRCDIR/libraries/lib-ffmpeg-support/"
}

termux_step_pre_configure() {
		CPPFLAGS+=" -Dushort=u_short -Dulong=u_long"
		CXXFLAGS+=" -std=c++17"
		LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/tenacity"
}

termux_step_post_make_install() {
		mv "$TERMUX_PREFIX/share/pixmaps/gnome-mime-application-x-audacity-project.xpm" \
		"$TERMUX_PREFIX/share/pixmaps/gnome-mime-application-x-tenacity-project.xpm"
}

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo
		echo "********"
		echo "Tenacity can not use microphone until you grant microphone access to Termux:API."
		echo "********"
		echo
	EOF
}
