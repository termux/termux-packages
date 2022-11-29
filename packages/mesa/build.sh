TERMUX_PKG_HOMEPAGE=https://www.mesa3d.org
TERMUX_PKG_DESCRIPTION="An open-source implementation of the OpenGL specification"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="docs/license.rst"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=22.2.4
TERMUX_PKG_SRCURL=https://archive.mesa3d.org/mesa-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=65d76b53ca5c7b46019e0e8e5b414de45d2fecd3fcd71707f6c3bc7691c9f7ab
TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libexpat, libx11, libxext, ncurses, zlib, zstd"
TERMUX_PKG_SUGGESTS="mesa-dev"
TERMUX_PKG_BUILD_DEPENDS="libdrm, libllvm-static, llvm, llvm-tools, mlir, xorgproto"
TERMUX_PKG_CONFLICTS="libmesa, ndk-sysroot (<= 25b)"
TERMUX_PKG_REPLACES="libmesa"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cmake-prefix-path $TERMUX_PREFIX
-Dcpp_rtti=false
-Dgbm=disabled
-Degl=disabled
-Dgles1=enabled
-Dgles2=enabled
-Ddri3=enabled
-Dllvm=enabled
-Dshared-llvm=disabled
-Dglx=xlib
-Dplatforms=x11
-Ddri-drivers=
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

termux_step_post_massage() {
	# A bunch of programs in the wild assume that the name of OpenGL shared
	# library is `libGL.so.1` and try to dlopen(3) it. In fact `sdl2` does
	# this. So please do not ever remove the symlink.
	cd ${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib || exit 1
	if [ ! -e "./libGL.so.1" ]; then
		ln -sf libGL.so libGL.so.1
	fi
}
