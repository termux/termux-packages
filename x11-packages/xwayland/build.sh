TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/wiki/
TERMUX_PKG_DESCRIPTION="Wayland X11 server"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.20.5
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a81d8243f37e75a03d4f8c55f96d0bc25802be6ec45c3bfa5cb614c6d01bac9d
TERMUX_PKG_DEPENDS="libandroid-shmem, libdrm, libpciaccess, libpixman, libx11, libxau, libxfont2, libxinerama, libxkbfile, libxshmfence, mesa, openssl, xkeyboard-config, xorg-xkbcomp, libwayland, libwayland-protocols, libepoxy"

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
--disable-xorg
--disable-glamor
--disable-dmx
--disable-xvfb
--disable-xnest
--enable-xwayland
--disable-xwin
--disable-kdrive
--disable-xephyr
--disable-libunwind
--enable-xshmfence
--enable-ipv6
--with-sha1=libcrypto
--with-fontrootdir=${TERMUX_PREFIX}/share/fonts
--with-xkb-path=${TERMUX_PREFIX}/share/X11/xkb
LIBS=-landroid-shmem"

termux_step_pre_configure () {
    CFLAGS+=" -fcommon -fPIC -DFNDELAY=O_NDELAY -Wno-int-to-pointer-cast"
    CPPFLAGS+=" -fcommon -fPIC -I${TERMUX_PREFIX}/include/libdrm"

    if [ "${TERMUX_DEBUG_BUILD}" = "true" ]; then
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
