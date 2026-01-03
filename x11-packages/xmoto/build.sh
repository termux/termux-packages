TERMUX_PKG_HOMEPAGE=https://xmoto.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="A challenging 2D motocross platform game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION="0.6.3"
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

	local packages
	packages+="fonts-arphic-bkai00mp,"
	packages+="fonts-dejavu-core,"
	packages+="fonts-dejavu-mono,"
	packages+="libasyncns0,"
	packages+="libccd2,"
	packages+="libchipmunk7,"
	packages+="libdecor-0-0,"
	packages+="libdecor-0-plugin-1-gtk,"
	packages+="libflac12t64,"
	packages+="libfluidsynth3,"
	packages+="libinstpatch-1.0-2,"
	packages+="libjack-jackd2-0,"
	packages+="libmodplug1,"
	packages+="libmp3lame0,"
	packages+="libmpg123-0t64,"
	packages+="libode8t64,"
	packages+="libogg0,"
	packages+="libopus0,"
	packages+="libopusfile0,"
	packages+="libpipewire-0.3-0t64,"
	packages+="libpipewire-0.3-common,"
	packages+="libpulse0,"
	packages+="libsamplerate0,"
	packages+="libsdl2-2.0-0,"
	packages+="libsdl2-mixer-2.0-0,"
	packages+="libsdl2-net-2.0-0,"
	packages+="libsdl2-ttf-2.0-0,"
	packages+="libsndfile1,"
	packages+="libspa-0.2-modules,"
	packages+="libvorbis0a,"
	packages+="libvorbisenc2,"
	packages+="libvorbisfile3,"
	packages+="libwebrtc-audio-processing1,"
	packages+="libxdg-basedir1,"
	packages+="libxss1,"
	packages+="timgm6mb-soundfont,"
	packages+="xmoto,"
	packages+="xmoto-data,"

	termux_download_ubuntu_packages "$packages"
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
