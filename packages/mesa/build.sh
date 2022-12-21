TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.3.1
TERMUX_PKG_SRCURL=https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3c9cd611c0859d307aba0659833386abdca4c86162d3c275ba5be62d16cf31eb
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libexpat, libx11, libxext, libxfixes, libxshmfence, libxxf86vm, ncurses, zlib, zstd"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BUILD_DEPENDS="libllvm-static, libxrandr, llvm, llvm-tools, mlir, xorgproto"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b)"
TERMUX_PKG_REPLACES="libmesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path $TERMUX_PREFIX
-Dcpp_rtti=false
-Dgbm=disabled
-Dopengl=true
-Degl=enabled
-Degl-native-platform=x11
-Dgles1=enabled
-Dgles2=enabled
-Ddri3=enabled
-Dglx=dri
-Dllvm=enabled
-Dshared-llvm=disabled
-Dplatforms=x11
-Dgallium-drivers=swrast
-Dvulkan-drivers=
-Dosmesa=true
"

termux_step_pre_configure() {
	termux_setup_cmake

	CPPFLAGS+=" -D__USE_GNU"
	LDFLAGS+=" -landroid-shmem"

	_WRAPPER_BIN=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	mkdir -p $_WRAPPER_BIN
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		sed 's|@CMAKE@|'"$(command -v cmake)"'|g' \
			$TERMUX_PKG_BUILDER_DIR/cmake-wrapper.in \
			> $_WRAPPER_BIN/cmake
		chmod 0700 $_WRAPPER_BIN/cmake
	fi
	export PATH=$_WRAPPER_BIN:$PATH
}

termux_step_post_configure() {
	rm -f $_WRAPPER_BIN/cmake
}

termux_step_post_make_install() {
	# A bunch of programs in the wild assume that the name of OpenGL shared
	# library is `libGL.so.1` and try to dlopen(3) it. In fact `sdl2` does
	# this. So please do not ever remove the symlink.
	ln -sf libGL.so ${TERMUX_PREFIX}/lib/libGL.so.1
	ln -sf libEGL.so ${TERMUX_PREFIX}/lib/libEGL.so.1
	ln -sf libGLESv1_CM.so ${TERMUX_PREFIX}/lib/libGLESv1_CM.so.1
	ln -sf libGLESv2.so ${TERMUX_PREFIX}/lib/libGLESv2.so.2

	patch -p1 -d $TERMUX_PREFIX/include < $TERMUX_PKG_BUILDER_DIR/egl-not-android.diff
}
