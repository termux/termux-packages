TERMUX_PKG_HOMEPAGE=https://wasmedge.org/
TERMUX_PKG_DESCRIPTION="A lightweight, high-performance, and extensible WebAssembly runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.spdx"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_SRCURL=https://github.com/WasmEdge/WasmEdge/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b4a48bf5a009d6c4bf99479f87bf3bf8ebd6386d636fdeb721540456330dce59
TERMUX_PKG_DEPENDS="libc++, libllvm"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, boost-static, libllvm-static, libpolly, lld, llvm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWASMEDGE_FORCE_DISABLE_LTO=ON
"

# Build failure for i686:
# ```
# [...]/wasmedge/src/thirdparty/wasi/api.hpp:55:1: error: static_assert failed
# due to requirement 'alignof(long long) == 8' "non-wasi data layout"
# static_assert(alignof(int64_t) == 8, "non-wasi data layout");
# ^             ~~~~~~~~~~~~~~~~~~~~~
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

termux_step_pre_configure() {
	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
