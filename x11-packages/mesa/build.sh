TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=21.3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b4fa9db7aa61bf209ef0b40bef83080999d86ad98df8b8b4fada7c128a1efc3d
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libx11, libxext, zlib, libexpat"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<< 23b-6)"
TERMUX_PKG_REPLACES="libmesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgbm=disabled
-Degl=disabled
-Dgles1=disabled
-Dgles2=disabled
-Ddri3=disabled
-Dllvm=disabled
-Dglx=xlib
-Dplatforms=x11
-Ddri-drivers=
-Dgallium-drivers=
-Dvulkan-drivers=
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
	LDFLAGS+=" -landroid-shmem"
}

termux_step_post_massage() {
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libGL.so.1" ]; then
		ln -sf libGL.so libGL.so.1
	fi
}
