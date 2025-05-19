TERMUX_PKG_HOMEPAGE=https://virgil3d.github.io/
TERMUX_PKG_DESCRIPTION="A virtual 3D GPU for use inside qemu virtual machines over OpenGLES libraries on Android"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="1.0.1"
_LIBEPOXY_VERSION="1.5.10"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=(
	https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-${TERMUX_PKG_VERSION}/virglrenderer-virglrenderer-${TERMUX_PKG_VERSION}.tar.gz
	https://github.com/anholt/libepoxy/archive/refs/tags/${_LIBEPOXY_VERSION}.tar.gz
)
TERMUX_PKG_SHA256=(
	446ab3e265f574ec598e77bdfbf0616ee3c77361f0574bec733ba4bac4df730a
	a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15
)
TERMUX_PKG_DEPENDS="angle-android"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	mv libepoxy-${_LIBEPOXY_VERSION} libepoxy
}

termux_step_host_build() {
if $TERMUX_ON_DEVICE_BUILD; then
	local _INSTALL_PREFIX=$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME
	CC=clang
	CXX=c++
	CROSS=
	# need android 30+
	# vim $PREFIX/include/sys/mman.h -c /memfd_create
	export CFLAGS="--target=aarch64-linux-android30 -w " 
else
	# This package should use the Android NDK toolchain to compile, not
	# our custom toolchain, so I'd like to compile it in the hostbuild step.
	export PATH="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"
	export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM$TERMUX_PKG_API_LEVEL
	if [ $TERMUX_ARCH = arm ]; then
		CCTERMUX_HOST_PLATFORM=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL
	fi
	local _INSTALL_PREFIX=$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME
	CC=$(command -v $CCTERMUX_HOST_PLATFORM-clang)
	CXX=$(command -v $CCTERMUX_HOST_PLATFORM-clang++)
	CROSS=--cross-file $TERMUX_MESON_CROSSFILE
	CFLAGS=
fi

	PKG_CONFIG="$TERMUX_PKG_TMPDIR/host-build-pkg-config"
	local _HOST_PKGCONFIG=$(command -v pkg-config)
	cat > $PKG_CONFIG <<-HERE
		#!/bin/sh
		export PKG_CONFIG_DIR=
		export PKG_CONFIG_LIBDIR=$_INSTALL_PREFIX/lib/pkgconfig
		exec $_HOST_PKGCONFIG "\$@"
	HERE
	chmod +x $PKG_CONFIG

	AR=$(command -v llvm-ar)
	LD=$(command -v ld.lld)
	CPPFLAGS=""
	CXXFLAGS=""
	export LDFLAGS="-Wl,-rpath=$_INSTALL_PREFIX/lib"
	STRIP=$(command -v llvm-strip)
	termux_setup_meson

	# Compile libepoxy
	mkdir -p libepoxy-build
	$TERMUX_MESON $TERMUX_PKG_SRCDIR/libepoxy libepoxy-build \
		$CROSS \
		--prefix=$_INSTALL_PREFIX \
		--libdir lib \
		-Degl=yes -Dglx=no -Dx11=false
	ninja -C libepoxy-build install -j $TERMUX_PKG_MAKE_PROCESSES

	# Compile virglrenderer
	mkdir -p virglrenderer-build
	$TERMUX_MESON $TERMUX_PKG_SRCDIR virglrenderer-build \
		$CROSS \
		--prefix=$_INSTALL_PREFIX \
		--libdir lib \
		-Dplatforms=egl \
		-Dvenus=true
	ninja -C virglrenderer-build install -j $TERMUX_PKG_MAKE_PROCESSES

	# i have to say everything twice as usual 
	patchelf --set-rpath $_INSTALL_PREFIX/lib $_INSTALL_PREFIX/bin/virgl_test_server

	# Move our virglrenderer binary to regular bin directory.
	mkdir $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin
	mv $_INSTALL_PREFIX/bin/virgl_test_server $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin/virgl-angle

	# Cleanup.
	rm -rf $_INSTALL_PREFIX/{bin,include,lib/pkgconfig}
}

termux_step_configure() {
	# Remove this marker all the time, as this package is architecture-specific
	rm -rf $TERMUX_HOSTBUILD_MARKER
}

termux_step_make() {
	:
}

termux_step_make_install() {
	:
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp $TERMUX_PKG_SRCDIR/COPYING $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-virglrenderer
	cp $TERMUX_PKG_SRCDIR/libepoxy/COPYING $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-libepoxy
	cp $TERMUX_PKG_BUILDER_DIR/COPYING-gl4es $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-gl4es
}
