TERMUX_PKG_HOMEPAGE=https://wasmedge.org/
TERMUX_PKG_DESCRIPTION="A lightweight, high-performance, and extensible WebAssembly runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.spdx"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.1"
# Use source tarball from release assets to get VERSION file for proper version number
TERMUX_PKG_SRCURL=https://github.com/WasmEdge/WasmEdge/releases/download/${TERMUX_PKG_VERSION}/WasmEdge-${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=e5a944975fb949ecda73d6fe80a86507deb2d0a221b2274338807b63758350b4
TERMUX_PKG_DEPENDS="libc++, libspdlog"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWASMEDGE_FORCE_DISABLE_LTO=ON
-DWASMEDGE_USE_LLVM=OFF
"
# Until fmt 11.0.3 is released with https://github.com/fmtlib/fmt/issues/4140:
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_pre_configure() {
	case "${TERMUX_ARCH}" in
	i686)
		CFLAGS+=" -malign-double"
		CXXFLAGS+=" -malign-double"
		;;
	esac
}

# wasmedge does not support LLVM 17 yet
# drop all AOT features which depends on libllvm

# WASMEDGE_BUILD_AOT_RUNTIME is not supported on i686
# https://github.com/WasmEdge/WasmEdge/blob/f6d99c87fef0db160d17ccf3f7f3cd87cbd56e68/lib/aot/compiler.cpp#L5032

# [...]/wasmedge/src/thirdparty/wasi/api.hpp:55:1: error: static_assert failed
# due to requirement 'alignof(long long) == 8' "non-wasi data layout"
# static_assert(alignof(int64_t) == 8, "non-wasi data layout");
# ^             ~~~~~~~~~~~~~~~~~~~~~
#
# Applying -malign-double will unblock i686 build at the expense of breaking something
