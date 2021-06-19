TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
## Use 17.3.x branch because 18.x.x requires 'pthread_barrier_t'.
TERMUX_PKG_VERSION=17.3.9
TERMUX_PKG_REVISION=34
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/older-versions/${TERMUX_PKG_VERSION:0:2}.x/mesa-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=c5beb5fc05f0e0c294fefe1a393ee118cb67e27a4dca417d77c297f7d4b6e479

TERMUX_PKG_DEPENDS="libandroid-shmem, libexpat, libdrm, libx11, libxdamage, libxext, libxml2, libxshmfence, zlib"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_CONFLICTS="libmesa"
TERMUX_PKG_REPLACES="libmesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--disable-asm
--disable-gbm
--disable-egl
--disable-gles1
--disable-gles2
--disable-dri
--disable-dri3
--disable-llvm
--enable-glx=xlib
--with-platforms=x11
--without-dri-drivers
--without-gallium-drivers
ac_cv_header_xlocale_h=no
"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem -latomic"
}

termux_step_post_massage() {
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libGL.so.1" ]; then
		ln -sf libGL.so libGL.so.1
	fi
}

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/mesa $TERMUX_PKG_BUILDER_DIR/LICENSE
}
