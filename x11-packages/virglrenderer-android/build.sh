TERMUX_PKG_HOMEPAGE=https://virgil3d.github.io/
TERMUX_PKG_DESCRIPTION="A virtual 3D GPU for use inside qemu virtual machines over OpenGLES libraries on Android"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=(0.10.4)
TERMUX_PKG_VERSION+=(1.5.10) # libepoxy version
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-${TERMUX_PKG_VERSION[0]}/virglrenderer-virglrenderer-${TERMUX_PKG_VERSION[0]}.tar.gz)
TERMUX_PKG_SRCURL+=(https://github.com/anholt/libepoxy/archive/refs/tags/${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(fd9a1b12473f4cda8d87e6ba1a6e5714a24355e16b69ed85df5c21bf48f797fa)
TERMUX_PKG_SHA256+=(a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15)

TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	mv libepoxy-${TERMUX_PKG_VERSION[1]} libepoxy
}

termux_step_host_build() {
	# This packages should use the Android NDK toolchain to compile, not
	# our custom toolchain, so I'd like to compile it in the hostbuild step.
	export PATH="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"
	export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM$TERMUX_PKG_API_LEVEL
	if [ $TERMUX_ARCH = arm ]; then
		CCTERMUX_HOST_PLATFORM=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL
	fi

	local _INSTALL_PREFIX=$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME

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
	CC=$(command -v $CCTERMUX_HOST_PLATFORM-clang)
	CXX=$(command -v $CCTERMUX_HOST_PLATFORM-clang++)
	LD=$(command -v ld.lld)
	CFLAGS=""
	CPPFLAGS=""
	CXXFLAGS=""
	LDFLAGS="-Wl,-rpath=\$ORIGIN/../lib"
	STRIP=$(command -v llvm-strip)
	termux_setup_meson

	# Compile libepoxy
	mkdir -p libepoxy-build
	$TERMUX_MESON $TERMUX_PKG_SRCDIR/libepoxy libepoxy-build \
        --cross-file $TERMUX_MESON_CROSSFILE \
        --prefix=$_INSTALL_PREFIX \
		--libdir lib \
        -Degl=yes -Dglx=no -Dx11=false
	ninja -C libepoxy-build install -j $TERMUX_MAKE_PROCESSES

	# Compile virglrenderer
	mkdir -p virglrenderer-build
	$TERMUX_MESON $TERMUX_PKG_SRCDIR virglrenderer-build \
        --cross-file $TERMUX_MESON_CROSSFILE \
        --prefix=$_INSTALL_PREFIX \
		--libdir lib \
        -Degl_without_gbm=true \
        -Dplatforms=egl
	ninja -C virglrenderer-build install -j $TERMUX_MAKE_PROCESSES

	# TODO: Build angle?
}

termux_step_configure() {
	# Remove this marker all the time, as this package is architecture-specific
	rm -rf $TERMUX_HOSTBUILD_MARKER
}

termux_step_make() {
	:
}

termux_step_make_install() {
	ln -sfr $TERMUX_PREFIX/opt/virglrenderer-android/bin/virgl_test_server $TERMUX_PREFIX/bin/virgl_test_server_android
}

termux_step_install_license() {
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp $TERMUX_PKG_SRCDIR/COPYING $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-virglrenderer
	cp $TERMUX_PKG_SRCDIR/libepoxy/COPYING $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-libepoxy
}
