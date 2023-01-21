TERMUX_PKG_HOMEPAGE=https://gitlab.freedesktop.org/glvnd/libglvnd
TERMUX_PKG_DESCRIPTION="The GL Vendor-Neutral Dispatch library"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/v${TERMUX_PKG_VERSION}/libglvnd-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=efc756ffd24b24059e1c53677a9d57b4b237b00a01c54a6f1611e1e51661d70c
TERMUX_PKG_DEPENDS="libc++, libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_BREAKS="mesa (<< 22.3.3-2)"
TERMUX_PKG_CONFLICTS="libmesa, mesa (<< 22.3.3-2), ndk-sysroot (<= 25b)"
TERMUX_PKG_REPLACES="libmesa, mesa (<< 22.3.3-2)"
TERMUX_PKG_RECOMMENDS="mesa"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtls=false
-Ddispatch-tls=false
"

termux_step_install_license() {
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME \
		$TERMUX_PKG_BUILDER_DIR/LICENSE
}

termux_step_post_make_install() {
	# A bunch of programs in the wild assume that the name of OpenGL shared
	# library is `libGL.so.1` and try to dlopen(3) it. In fact `sdl2` does
	# this. So please do not ever remove the symlink.
	ln -sf libGL.so ${TERMUX_PREFIX}/lib/libGL.so.1
	ln -sf libEGL.so ${TERMUX_PREFIX}/lib/libEGL.so.1
	ln -sf libGLESv1_CM.so ${TERMUX_PREFIX}/lib/libGLESv1_CM.so.1
	ln -sf libGLESv2.so ${TERMUX_PREFIX}/lib/libGLESv2.so.2
	ln -sf libGLX.so ${TERMUX_PREFIX}/lib/libGLX.so.0
	ln -sf libOpenGL.so ${TERMUX_PREFIX}/lib/libOpenGL.so.0

	patch -p1 -d $TERMUX_PREFIX/include < $TERMUX_PKG_BUILDER_DIR/egl-not-android.diff
}
