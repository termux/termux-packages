TERMUX_PKG_HOMEPAGE=https://xmoto.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="A challenging 2D motocross platform game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION="0.6.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/xmoto/xmoto/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=64cb29934660456ec82cebdaa0d3d273a862e10760e8ee80443928d317242484
TERMUX_PKG_DEPENDS="bzip2, game-music-emu, glu, libcurl, libjpeg-turbo, libpng, libwavpack, libx11, libxdg-basedir, lua54, sdl2 | sdl2-compat, sdl2-mixer, sdl2-net, sdl2-ttf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_GROUPS="games"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local -a ubuntu_packages=(
		"fonts-arphic-bkai00mp"
		"fonts-dejavu-core"
		"fonts-dejavu-mono"
		"libasyncns0"
		"libccd2"
		"libchipmunk7"
		"libdecor-0-0"
		"libdecor-0-plugin-1-gtk"
		"libflac12t64"
		"libfluidsynth3"
		"libinstpatch-1.0-2"
		"libjack-jackd2-0"
		"libmodplug1"
		"libmp3lame0"
		"libmpg123-0t64"
		"libode8t64"
		"libogg0"
		"libopus0"
		"libopusfile0"
		"libpipewire-0.3-0t64"
		"libpipewire-0.3-common"
		"libpulse0"
		"libsamplerate0"
		"libsdl2-2.0-0"
		"libsdl2-mixer-2.0-0"
		"libsdl2-net-2.0-0"
		"libsdl2-ttf-2.0-0"
		"libsndfile1"
		"libspa-0.2-modules"
		"libvorbis0a"
		"libvorbisenc2"
		"libvorbisfile3"
		"libwebrtc-audio-processing1"
		"libxdg-basedir1"
		"libxss1"
		"timgm6mb-soundfont"
		"xmoto"
		"xmoto-data"
	)

	termux_download_ubuntu_packages "${ubuntu_packages[@]}"
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
		export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu"
		LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
		LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib/x86_64-linux-gnu/pulseaudio"
		export PATH="${HOSTBUILD_ROOTFS}/usr/games:$PATH"
	fi
}
