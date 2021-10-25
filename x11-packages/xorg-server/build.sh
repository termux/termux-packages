TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Xorg server"
TERMUX_PKG_VERSION=1.20.11
TERMUX_PKG_REVISION=1
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=914c796e3ffabe1af48071d40ccc85e92117c97a9082ed1df29e4d64e3c34c49

#i686 gives the following error...
#relocation R_386_GOTOFF against preemptible symbol fbdevHWLoadPalette cannot be used when making a shared object

TERMUX_PKG_BLACKLISTED_ARCHES="i686"

TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libpciaccess, libpixman, libx11, libxau, libxfont2, libxinerama, libxkbfile, libxshmfence, mesa, openssl, xkeyboard-config, xorg-xkbcomp"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-composite
--enable-mitshm
--enable-xres
--enable-record
--enable-xv
--enable-xvmc
--enable-dga
--enable-screensaver
--enable-xdmcp
--disable-glx
--disable-dri
--disable-dri2
--disable-dri3
--enable-present
--disable-tests
--enable-xinerama
--enable-xf86vidmode
--enable-xace
--enable-xcsecurity
--enable-dbe
--enable-xf86bigfont
--disable-xfree86-utils
--disable-vgahw
--disable-vbe
--disable-int10-module
--enable-libdrm
--disable-pciaccess
--disable-linux-acpi
--disable-linux-apm
--enable-xorg
--disable-glamor
--disable-dmx
--disable-xvfb
--disable-xnest
--disable-xwayland
--disable-xwin
--disable-kdrive
--enable-xephyr
--disable-libunwind
--enable-xshmfence
--enable-ipv6
--with-sha1=libcrypto
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
--with-xkb-path=${TERMUX_PREFIX}/share/X11/xkb
LIBS=-landroid-shmem"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon -fPIC -DFNDELAY=O_NDELAY -Wno-int-to-pointer-cast"
	CPPFLAGS+=" -fcommon -fPIC -I${TERMUX_PREFIX}/include/libdrm"

	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-debug"
	fi

	# fixing automake version mismatch
	cd ${TERMUX_PKG_SRCDIR}
	files=`find . -name configure -o -name config.status -o -name Makefile.in`
	for file in $files; do rm $file; done
	unset files

	#you will need xutils-dev package for xorg-macros installed
	autoreconf -if
	cd -
}

termux_step_post_make_install () {
	rm -f "${TERMUX_PREFIX}/usr/share/X11/xkb/compiled"
}

## The following is required for package 'tigervnc'.
if [ "${#}" -eq 1 ] && [ "${1}" == "xorg_server_flags" ]; then
	echo ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
	return
fi
