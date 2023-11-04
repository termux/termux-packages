TERMUX_PKG_HOMEPAGE=https://wasmedge.org/
TERMUX_PKG_DESCRIPTION="A lightweight, high-performance, and extensible WebAssembly runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.spdx"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.5"
TERMUX_PKG_SRCURL=https://github.com/WasmEdge/WasmEdge/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=588b8933a89f75c3ee5d4b92fe9d65294ae86fd48a95d2d4ac1a93ee3c5e1d75
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWASMEDGE_BUILD_AOT_RUNTIME=OFF
-DWASMEDGE_FORCE_DISABLE_LTO=ON
"

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
