TERMUX_PKG_HOMEPAGE=https://ccache.samba.org
TERMUX_PKG_DESCRIPTION="Compiler cache for fast recompilation of C/C++ code"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.10.1"
TERMUX_PKG_SRCURL=https://github.com/ccache/ccache/releases/download/v$TERMUX_PKG_VERSION/ccache-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=3a43442ce3916ea48bb6ccf6f850891cbff01d1feddff7cd4bbd49c5cf1188f6
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libhiredis, xxhash, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="fmt"

#[46/89] Building ASM object src/third_party/blake3/CMakeFiles/blake3.dir/blake3_sse2_x86-64_unix.S.o
#FAILED: src/third_party/blake3/CMakeFiles/blake3.dir/blake3_sse2_x86-64_unix.S.o
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DDEPS=LOCAL
-DENABLE_TESTING=OFF
-DHAVE_ASM_AVX2=FALSE
-DHAVE_ASM_AVX512=FALSE
-DHAVE_ASM_SSE2=FALSE
-DHAVE_ASM_SSE41=FALSE
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-spawn"
}
