TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X.org framebuffer video driver"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/driver/xf86-video-fbdev-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=dcc3d85f378022180e437a9ec00a59b6cb7680ff79c40394d695060af2374699
TERMUX_PKG_DEPENDS="freetype, libandroid-shmem, libpixman, libxau, libxdmcp, libxfont2, libxshmfence, openssl, xorg-server"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
    export LDFLAGS="${LDFLAGS} -lXFree86"
}
