TERMUX_PKG_HOMEPAGE=https://www.audacityteam.org/
TERMUX_PKG_DESCRIPTION="An easy-to-use, multi-track audio editor and recorder"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.7.6"
TERMUX_PKG_SRCURL="https://github.com/audacity/audacity/archive/Audacity-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5d1026e2674c0282b2ba279c1f00bd176a9dfdaa45a66877cb6a4f2d8b3ce1da
TERMUX_PKG_DEPENDS="ffmpeg, gdk-pixbuf, glib, gtk3, libc++, libexpat, libflac, libid3tag, libogg, libopus, libsndfile, libsoundtouch, libsoxr, libuuid, libvorbis, libwavpack, libmpg123, opusfile, portaudio, portmidi, wxwidgets"
TERMUX_PKG_BUILD_DEPENDS="libjpeg-turbo, libjpeg-turbo-static, libmp3lame, libpng, rapidjson, zlib"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_STRIP=llvm-strip
-Daudacity_conan_enabled=off
-Daudacity_has_vst3=no
-Daudacity_has_tests=no
-Daudacity_has_networking=no
-Daudacity_has_crashreports=no
-Daudacity_has_sentry_reporting=no
-Daudacity_has_updates_check=no
-Daudacity_use_wxwidgets=system
-Daudacity_use_expat=system
-Daudacity_use_lame=system
-Daudacity_use_soxr=system
-Daudacity_use_portaudio=system
-Daudacity_use_ffmpeg=loaded
-Daudacity_use_nyquist=local
-Daudacity_use_vamp=off
-Daudacity_use_lv2=off
-Daudacity_use_midi=system
-Daudacity_use_portmixer=local
-Daudacity_use_portsmf=local
-Daudacity_use_sbsms=off
-Daudacity_use_soundtouch=system
-Daudacity_use_twolame=off
-DUSE_MIDI=OFF
"

# Function to obtain the .deb URL
obtain_deb_url() {
	local url="https://packages.ubuntu.com/noble/amd64/$1/download"
	local retries=5
	local wait=5
	local attempt
	local deb_url

	for ((attempt=1; attempt<=retries; attempt++)); do
		local PAGE="$(curl -s "$url")"
		>&2 echo page
		>&2 echo "$PAGE"
		if deb_url=$(echo "$PAGE" | grep -Eo 'http://.*\.deb' | head -n 1); then
			if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
			else
				# deb_url is empty or server answered with `internal server error`, retry
				>&2 echo "Attempt $attempt: Received empty URL or server answered with `Internal server error` page. Retrying in $wait seconds..."
			fi
		else
			# The command failed, retry
			>&2 echo "Attempt $attempt: Command failed. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done

	# Failed after retries, output error to stderr and exit with code 1
	>&2 echo "Failed to obtain URL after $retries attempts."
	exit 1
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	( # Running build in a subshell to avoid variable mess
		# We must build the `image-compiler` for building.
		# See https://github.com/audacity/audacity/blob/Audacity-3.6.4/BUILDING.md#selecting-target-architecture-on-macos
		_PREFIX="$TERMUX_PKG_HOSTBUILD_DIR/prefix"

		# Building both gtk2.0 and alsa only for building host-side tool seems to be excessive.
		# Let's download them from ubuntu repos.
		# To avoid messing with `apt update` and `apt download` we will get download links directly from ubuntu servers.
		mkdir "$_PREFIX"
		for i in libgtk2.0-0t64 libgtk2.0-dev libasound2-dev; do
			wget "$(obtain_deb_url $i)" -O "$TERMUX_PKG_HOSTBUILD_DIR/tmp.deb"
			dpkg-deb -R "$TERMUX_PKG_HOSTBUILD_DIR/tmp.deb" "$TERMUX_PKG_HOSTBUILD_DIR/tmp"
			cp -rf "$TERMUX_PKG_HOSTBUILD_DIR"/tmp/* "$_PREFIX"
			rm -rf "$TERMUX_PKG_HOSTBUILD_DIR/tmp.deb" "$TERMUX_PKG_HOSTBUILD_DIR/tmp"
			unset _URL
		done

		for i in "$_PREFIX"/usr/lib/x86_64-linux-gnu/pkgconfig/*.pc; do
			# patch pkg-config files to match new prefix
			sed -i '/^prefix=/c\prefix='"$_PREFIX/usr" "$i"
		done

		# Also we should import pkg-config configuration files from the packages we imported from ubuntu repos
		_LIBDIR="$_PREFIX/usr/lib/x86_64-linux-gnu"
		export PKG_CONFIG_LIBDIR="$_LIBDIR/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/share/pkgconfig"
		export CFLAGS="-I$_PREFIX/usr/include"
		export LDFLAGS="-Wl,-rpath,$_LIBDIR"
		export CMAKE_INCLUDE_PATH="$_PREFIX/usr/include:$_LIBDIR/gtk-2.0/include"
		export CMAKE_LIBRARY_PATH="$_LIBDIR"
		cmake -GNinja -B "$TERMUX_PKG_HOSTBUILD_DIR" -S "$TERMUX_PKG_SRCDIR" -DCMAKE_BUILD_TYPE=Release
		ninja -C "$TERMUX_PKG_HOSTBUILD_DIR" image-compiler
	)
}

termux_step_pre_configure() {
	CPPFLAGS+=" -Dushort=u_short -Dulong=u_long"
	CXXFLAGS+=" -std=c++17"
	# Adding `image-compiler` we built in host_build step
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/Release/bin:$PATH"
	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/audacity"
	# For some reason `image-compiler` fails to find it's libraries in our custom prefix, let's help it.
	export LD_LIBRARY_PATH="$TERMUX_PKG_HOSTBUILD_DIR/prefix/usr/lib/x86_64-linux-gnu"
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
