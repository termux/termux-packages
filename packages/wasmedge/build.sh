TERMUX_PKG_HOMEPAGE=https://wasmedge.org
TERMUX_PKG_DESCRIPTION="A lightweight, high-performance, and extensible WebAssembly runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.spdx"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.4"
TERMUX_PKG_SRCURL=https://github.com/WasmEdge/WasmEdge/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3771fb4b85cd1cb51896f7b691a0ecb784517b64caa13f624a1383818f678237
TERMUX_PKG_DEPENDS="libc++, libllvm, zlib, zstd"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, boost-static, libllvm-static, libpolly, lld, llvm"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWASMEDGE_FORCE_DISABLE_LTO=ON
"

# WASMEDGE_BUILD_AOT_RUNTIME is not supported on i686
# https://github.com/WasmEdge/WasmEdge/blob/f6d99c87fef0db160d17ccf3f7f3cd87cbd56e68/lib/aot/compiler.cpp#L5032
if [[ "${TERMUX_ARCH}" == "i686" ]]; then
	TERMUX_PKG_DEPENDS="libc++"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DWASMEDGE_BUILD_AOT_RUNTIME=OFF"
fi

# Build failure for i686 (0.9.1):
# ```
# [...]/wasmedge/src/thirdparty/wasi/api.hpp:55:1: error: static_assert failed
# due to requirement 'alignof(long long) == 8' "non-wasi data layout"
# static_assert(alignof(int64_t) == 8, "non-wasi data layout");
# ^             ~~~~~~~~~~~~~~~~~~~~~
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="i686"
