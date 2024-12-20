TERMUX_PKG_HOMEPAGE=https://github.com/stsp/thunk_gen
TERMUX_PKG_DESCRIPTION="thunk generator for C and assembler"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@stsp"
TERMUX_PKG_VERSION=1.2
TERMUX_PKG_SRCURL=git+https://github.com/stsp/thunk_gen.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="flex, bison"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	export PATH="$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"
	export CCTERMUX_HOST_PLATFORM=$TERMUX_HOST_PLATFORM$TERMUX_PKG_API_LEVEL
	if [ $TERMUX_ARCH = arm ]; then
		CCTERMUX_HOST_PLATFORM=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL
	fi

	local _INSTALL_PREFIX=$TERMUX_PREFIX/opt/$TERMUX_PKG_NAME

	PKG_CONFIG=$(command -v pkg-config)
	AR=$(command -v llvm-ar)
	CC=$(command -v $CCTERMUX_HOST_PLATFORM-clang)
	CXX=$(command -v $CCTERMUX_HOST_PLATFORM-clang++)
	LD=$(command -v ld.lld)
	CFLAGS=""
	CPPFLAGS=""
	CXXFLAGS=""
	LDFLAGS="-Wl,-rpath=$_INSTALL_PREFIX/lib"
	STRIP=$(command -v llvm-strip)
	termux_setup_meson
	$TERMUX_MESON setup --prefix $_INSTALL_PREFIX \
		$TERMUX_PKG_HOSTBUILD_DIR $TERMUX_PKG_SRCDIR
	$TERMUX_MESON compile --verbose -C $TERMUX_PKG_HOSTBUILD_DIR
	$TERMUX_MESON install -C $TERMUX_PKG_HOSTBUILD_DIR
}

termux_step_configure() {
	termux_setup_meson
	termux_step_configure_meson
}

termux_step_make() {
	$TERMUX_MESON compile --verbose -C $TERMUX_PKG_BUILDDIR
}

termux_step_make_install() {
	$TERMUX_MESON install -C $TERMUX_PKG_BUILDDIR
}
