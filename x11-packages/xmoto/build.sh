TERMUX_PKG_HOMEPAGE=https://xmoto.tuxfamily.org/
TERMUX_PKG_DESCRIPTION="A challenging 2D motocross platform game"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@IntinteDAO"
TERMUX_PKG_VERSION="0.6.3"
TERMUX_PKG_REVISION=2
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
		# xmoto
		"xmoto"
		"fonts-arphic-bkai00mp"
		"fonts-dejavu-mono"
		"libchipmunk7"
		"libopusfile0"
		"libsdl2-net-2.0-0"
		"libvorbisfile3"
		"libxmp4"
		"fonts-dejavu-core"
		"libccd2"
		"libode8t64"
		"libsdl2-mixer-2.0-0"
		"libsdl2-ttf-2.0-0"
		"libxdg-basedir1"
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
