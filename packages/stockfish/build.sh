TERMUX_PKG_HOMEPAGE=https://stockfishchess.org/
TERMUX_PKG_DESCRIPTION="Free and strong UCI chess engine"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="17.1"
TERMUX_PKG_SRCURL="https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0cfd9396438798cc68f5c0d5fa0bb458bb8ffff7de06add841aaeace86bec1f1
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
-C src
COMP=clang
PREFIX=$TERMUX_PREFIX
"

termux_step_configure() {
	local TARGET_ARCH
	# 64-bit ARM Android 7.0 is thought to require CPUs with at least armv8 instructions, but not more
	# 32-bit ARM Android 7.0 is thought to require CPUs with at least armv7-neon instructions, but not more
	# 64-bit x86 Android 7.0 is thought to require CPUs with at least x86-64-sse41-popcnt instructions, but not more
	# 32-bit x86 Android 7.0 is thought to require CPUs with at least x86-32-sse2 instructions, but not more
	case "$TERMUX_ARCH" in
		'aarch64') TARGET_ARCH='armv8';;
		'arm')     TARGET_ARCH='armv7-neon';;
		'x86_64')  TARGET_ARCH='x86-64-sse41-popcnt';;
		'i686')    TARGET_ARCH='x86-32-sse2';;
		*) termux_error_exit "Architecture not supported by build system"
	esac
	TERMUX_PKG_EXTRA_MAKE_ARGS+=" ARCH=$TARGET_ARCH COMPCXX=$CXX STRIP=$STRIP"
}

termux_step_make() {
	make net   $TERMUX_PKG_EXTRA_MAKE_ARGS -j"$TERMUX_PKG_MAKE_PROCESSES"
	make build $TERMUX_PKG_EXTRA_MAKE_ARGS -j"$TERMUX_PKG_MAKE_PROCESSES"
}
