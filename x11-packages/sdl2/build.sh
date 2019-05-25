TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard (version 2)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.0.9
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.libsdl.org/release/SDL2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=255186dc676ecd0c1dbf10ec8a2cc5d6869b5079d8a38194c2aecdff54b324b1

TERMUX_PKG_DEPENDS="libandroid-glob, libflac, libogg, libpulseaudio, libsndfile, libvorbis, libx11, libxau, libxcb, libxcursor, libxdmcp, libxext, libxfixes, libxi, libxinerama, libxrandr, libxrender, libxss, libxxf86vm"
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
--disable-video-mir
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
--disable-input-tslib
--enable-pthreads
--disable-pthread-sem
--disable-directx
--disable-sdl-dlopen
--disable-render-d3d
"
