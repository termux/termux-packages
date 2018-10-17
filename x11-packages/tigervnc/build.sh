TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://www.tigervnc.org/
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_REVISION=15
TERMUX_PKG_DESCRIPTION="Suite of VNC servers. Based on the VNC 4 branch of TightVNC."
TERMUX_PKG_SRCURL=https://github.com/TigerVNC/tigervnc/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f15ced8500ec56356c3bf271f52e58ed83729118361c7103eab64a618441f740

TERMUX_PKG_DEPENDS="freetype, libandroid-support, libandroid-shmem, libbz2, libc++, libdrm, libexpat, libgnutls, libjpeg-turbo, libpixman, libpng, libuuid, libx11, libxau, libxcb, libxdamage, libxdmcp, libxext, libxxf86vm, libxfixes, libxfont2, libxshmfence, mesa, openssl, perl, xkeyboard-config, xorg-xauth, xorg-xkbcomp"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-font-util, xorg-util-macros, xorg-server-xvfb, xtrans"
TERMUX_PKG_SUGGESTS="aterm, xorg-twm"

TERMUX_PKG_FOLDERNAME=tigervnc-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-DBUILD_VIEWER=ON -DENABLE_NLS=OFF -DENABLE_PAM=OFF -DENABLE_GNUTLS=ON"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
    mkdir -p ${TERMUX_PKG_BUILDDIR}/unix/xserver
    cd ${TERMUX_PKG_BUILDDIR}/unix/xserver

    cp -R ${TERMUX_TOPDIR}/xorg-server-xvfb/src/* ${TERMUX_PKG_BUILDDIR}/unix/xserver/

    patch -p1 -i ${TERMUX_PKG_SRCDIR}/unix/xserver120.patch

    export ACLOCAL="aclocal -I ${TERMUX_PREFIX}/share/aclocal"
    autoreconf -fi

    CFLAGS="${CFLAGS} -DFNDELAY=O_NDELAY -DINITARGS=void"
    CPPFLAGS="${CPPFLAGS} -I${TERMUX_PREFIX}/include/libdrm"
    LDFLAGS="${LDFLAGS} -llog"

    ./configure \
        --host="${TERMUX_HOST_PLATFORM}" \
        --prefix="${TERMUX_PREFIX}" \
        --disable-static \
        --disable-nls \
        --enable-debug \
        `TERMUX_PREFIX=${TERMUX_PREFIX} bash ${TERMUX_SCRIPTDIR}/packages/xorg-server-xvfb/build.sh xorg_server_flags`

    LDFLAGS="${LDFLAGS} -landroid-shmem"
}

termux_step_post_make_install () {
    cd ${TERMUX_PKG_BUILDDIR}/unix/xserver
    make -j ${TERMUX_MAKE_PROCESSES}

    cd ${TERMUX_PKG_BUILDDIR}/unix/xserver/hw/vnc
    make install

    ## use custom variant of vncserver script
    cp -f "${TERMUX_PKG_BUILDER_DIR}/vncserver" "${TERMUX_PREFIX}/bin/vncserver"
}
