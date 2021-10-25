TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.15
TERMUX_PKG_REVISION=42
TERMUX_PKG_SRCURL=https://www.libsdl.org/release/SDL-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00
TERMUX_PKG_DEPENDS="libandroid-glob, libflac, libogg, libsndfile, libvorbis, libx11, libxext, libxrandr, libxrender, pulseaudio"
TERMUX_PKG_CONFLICTS="libsdl"
TERMUX_PKG_REPLACES="libsdl"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-assembly
--disable-nasm
--disable-pth
--disable-video-opengl
"
