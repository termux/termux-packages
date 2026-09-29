TERMUX_PKG_HOMEPAGE=https://github.com/jeremy-rifkin/cpptrace
TERMUX_PKG_DESCRIPTION="Self-contained stacktrace library for C++11 and newer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.4"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL="https://github.com/jeremy-rifkin/cpptrace/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=5c9f5b301e903714a4d01f1057b9543fa540f7bfcc5e3f8bd1748e652e24f9ea
TERMUX_PKG_DEPENDS="libc++, libdwarf, zstd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCPPTRACE_BUILD_SHARED=ON
-DCPPTRACE_FIND_LIBDWARF_WITH_PKGCONFIG=ON
-DCPPTRACE_USE_EXTERNAL_LIBDWARF=ON
-DCPPTRACE_USE_EXTERNAL_ZSTD=ON
"

termux_step_pre_configure() {
	# prevents this error during linking reverse dependencies:
	# ld.lld: error: undefined reference: ZSTD_decompress
	# >>> referenced by /data/data/com.termux/files/usr/lib/libcpptrace.so.1.0.4
	LDFLAGS+=" -lzstd"
}
