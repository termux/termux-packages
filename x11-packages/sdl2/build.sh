TERMUX_PKG_HOMEPAGE=https://www.libsdl.org
TERMUX_PKG_DESCRIPTION="A library for portable low-level access to a video framebuffer, audio output, mouse, and keyboard (version 2)"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.32.0"
TERMUX_PKG_SRCURL=https://www.libsdl.org/release/SDL2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f5c2b52498785858f3de1e2996eba3c1b805d08fe168a47ea527c7fc339072d0
TERMUX_PKG_DEPENDS="libdecor, libiconv, libwayland, libx11, libxcursor, libxext, libxfixes, libxi, libxkbcommon, libxrandr, libxss, pulseaudio"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols, opengl"
TERMUX_PKG_RECOMMENDS="opengl"
TERMUX_PKG_CONFLICTS="libsdl2"
TERMUX_PKG_REPLACES="libsdl2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-3dnow
--disable-alsa
--disable-assembly
--disable-dbus
--disable-directx
--disable-esd
--disable-fcitx
--disable-ibus
--disable-ime
--disable-libudev
--disable-mmx
--disable-oss
--disable-pthread-sem
--disable-render-d3d
--disable-render-metal
--disable-video-cocoa
--disable-video-kmsdrm
--disable-video-rpi
--disable-video-vivante
--enable-libdecor
--enable-pthreads
--enable-video-opengl
--enable-video-opengles
--enable-video-opengles1
--enable-video-opengles2
--enable-video-vulkan
--enable-video-wayland
--enable-video-x11-scrnsaver
--enable-video-x11-xcursor
--enable-video-x11-xdbe
--enable-video-x11-xfixes
--enable-video-x11-xinput
--enable-video-x11-xrandr
--enable-video-x11-xshape
--x-includes=${TERMUX_PREFIX}/include
--x-libraries=${TERMUX_PREFIX}/lib
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

	termux_setup_wayland_cross_pkg_config_wrapper
}

termux_step_post_massage() {
	# ld(1)ing with `-lSDL2` won't work without this:
	# https://github.com/termux/x11-packages/issues/633
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libSDL2.so" ]; then
		ln -sf libSDL2-2.0.so libSDL2.so
	fi
}
