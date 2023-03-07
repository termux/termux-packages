TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.26.4
TERMUX_PKG_SRCURL=https://www.libsdl.org/release/SDL2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1a0f686498fb768ad9f3f80b39037a7d006eac093aad39cb4ebcc832a8887231
TERMUX_PKG_DEPENDS="libx11, libxcursor, libxext, libxfixes, libxi, libxrandr, libxss, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="opengl"
TERMUX_PKG_RECOMMENDS="opengl"
TERMUX_PKG_CONFLICTS="libsdl2"
TERMUX_PKG_REPLACES="libsdl2"

TERMUX_PKG_AUTO_UPDATE=true

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
--disable-video-kmsdrm
--enable-video-opengl
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

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(sed -En 's/^LT_MAJOR=([0-9]+).*/\1/p' configure.ac)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	rm -rf "$TERMUX_PKG_SRCDIR"/Xcode-iOS
	find "$TERMUX_PKG_SRCDIR" -type f | \
		xargs -n 1 sed -i \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)\(__[^A-Za-z0-9_]\)/\1_NO_TERMUX\2/g' \
		-e 's/\([^A-Za-z0-9_]__ANDROID\)__$/\1_NO_TERMUX__/g'
}

termux_step_post_massage() {
	# ld(1)ing with `-lSDL2` won't work without this:
	# https://github.com/termux/x11-packages/issues/633
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libSDL2.so" ]; then
		ln -sf libSDL2-2.0.so libSDL2.so
	fi
}
