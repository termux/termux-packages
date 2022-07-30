TERMUX_PKG_HOMEPAGE=https://github.com/rui314/mold
TERMUX_PKG_DESCRIPTION="mold: A Modern Linker"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/rui314/mold/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d436e2d4c1619a97aca0e28f26c4e79c0242d10ce24e829c1b43cfbdd196fd77
TERMUX_PKG_DEPENDS="libc++, openssl, zlib, libandroid-spawn"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	# onetbb use cmake
	termux_setup_cmake
}

termux_step_make() {
	# Have to override Makefile variables here
	# else need to patch Makefile
	# When building mold-wrapper.so cant find
	# spawn.h from libandroid-spawn for some reason
	# Manually link just in case to avoid runtime surprises
	make -j "$TERMUX_MAKE_PROCESSES" \
		PREFIX="$TERMUX_PREFIX" \
		CFLAGS="$CFLAGS -I${TERMUX_PREFIX}/include" \
		CXXFLAGS="$CXXFLAGS -I${TERMUX_PREFIX}/include" \
		STRIP="$STRIP" \
		MOLD_WRAPPER_LDFLAGS=" -ldl -landroid-spawn"
}

termux_step_make_install() {
	make -j "$TERMUX_MAKE_PROCESSES" install \
		PREFIX="$TERMUX_PREFIX" \
		CFLAGS="$CFLAGS -I${TERMUX_PREFIX}/include" \
		CXXFLAGS="$CXXFLAGS -I${TERMUX_PREFIX}/include" \
		STRIP="$STRIP" \
		MOLD_WRAPPER_LDFLAGS=" -ldl -landroid-spawn"
}
