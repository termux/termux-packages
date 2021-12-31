TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.18
TERMUX_PKG_SRCURL=https://www.libsdl.org/release/SDL2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=94d40cd73dbfa10bb6eadfbc28f355992bb2d6ef6761ad9d4074eff95ee5711c
TERMUX_PKG_DEPENDS="libandroid-glob, libflac, libogg, libsndfile, libvorbis, libx11, libxau, libxcb, libxcursor, libxdmcp, libxext, libxfixes, libxi, libxinerama, libxrandr, libxrender, libxss, libxxf86vm, pulseaudio"
TERMUX_PKG_CONFLICTS="libsdl2"
TERMUX_PKG_REPLACES="libsdl2"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--x-includes=${TERMUX_PREFIX}/include
--x-libraries=${TERMUX_PREFIX}/lib
--disable-assembly
--disable-mmx
--disable-3dnow
--disable-oss
--disable-alsa
--disable-esd
--disable-video-wayland
--disable-video-rpi
--enable-video-x11-xcursor
--enable-video-x11-xinerama
--enable-video-x11-xinput
--enable-video-x11-xrandr
--enable-video-x11-scrnsaver
--enable-video-x11-xshape
--enable-video-x11-vm
--disable-video-vivante
--disable-video-cocoa
--disable-render-metal
--disable-video-opengl
--disable-video-opengles
--disable-video-opengles2
--disable-video-vulkan
--disable-libudev
--disable-dbus
--disable-ime
--disable-ibus
--disable-fcitx
--enable-pthreads
--disable-pthread-sem
--disable-directx
--disable-render-d3d
"

termux_step_pre_configure() {
	rm -rf "$TERMUX_PKG_SRCDIR"/Xcode-iOS
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)\(__[^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)__$/\1_NO_TERMUX__/g'
}
