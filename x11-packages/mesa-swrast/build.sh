TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

## Required by GLX functionality of Xvnc/Xvfb servers and shouldn't be
## used by used by regular applications.
##
## Cannot built as part of package 'mesa' since --enable-glx=xlib
## require DRI to be disabled.

TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="The legacy/original Mesa software rasterizer"
## Use 17.3.x branch because 18.x.x requires 'pthread_barrier_t'.
TERMUX_PKG_VERSION=17.3.9
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c5beb5fc05f0e0c294fefe1a393ee118cb67e27a4dca417d77c297f7d4b6e479

TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libexpat, mesa"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-asm
--disable-gbm
--disable-egl
--disable-gles1
--disable-gles2
--enable-glx=dri
--with-platforms=x11
--with-dri-drivers=swrast
--without-gallium-drivers
ac_cv_header_xlocale_h=no
"

termux_step_pre_configure () {
    export LIBS="-landroid-shmem -latomic"
}

termux_step_make_install() {
    install -Dm600 ./lib/swrast_dri.so "${TERMUX_PREFIX}/lib/dri/swrast_dri.so"

    install \
        -Dm600 \
        "${TERMUX_PKG_SRCDIR}/include/GL/internal/dri_interface.h" \
        "${TERMUX_PREFIX}/include/GL/internal/dri_interface.h"
}
