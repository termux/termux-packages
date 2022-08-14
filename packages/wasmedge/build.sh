TERMUX_PKG_HOMEPAGE=https://wasmedge.org
TERMUX_PKG_DESCRIPTION="A lightweight, high-performance, and extensible WebAssembly runtime"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE.spdx"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.10.1
TERMUX_PKG_SRCURL=https://github.com/WasmEdge/WasmEdge/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f87bf06be0b94e8fcf974b6029f1f7ab46fd7526de33bff70d9cf4117512d07a
TERMUX_PKG_DEPENDS="libc++, libllvm"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, boost-static, libllvm-static, libpolly, lld, llvm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DWASMEDGE_FORCE_DISABLE_LTO=ON
"

# Build failure for i686 (0.9.1):
# ```
# [...]/wasmedge/src/thirdparty/wasi/api.hpp:55:1: error: static_assert failed
# due to requirement 'alignof(long long) == 8' "non-wasi data layout"
# static_assert(alignof(int64_t) == 8, "non-wasi data layout");
# ^             ~~~~~~~~~~~~~~~~~~~~~
# ```
# Build failure for i686 (0.10.1):
# [14/83] Building CXX object lib/system/CMakeFiles/wasmedgeSystem.dir/allocator.cpp.o
# FAILED: lib/system/CMakeFiles/wasmedgeSystem.dir/allocator.cpp.o
# ...
# /home/builder/.termux-build/wasmedge/src/lib/system/allocator.cpp:149:42: error: use of undeclared identifier 'PROT_READ'
#  if (auto Pointer = mmap(nullptr, Size, PROT_READ | PROT_WRITE,
#                                         ^
# Build failure for arm (0.10.1):
# [23/83] Building CXX object lib/plugin/CMakeFiles/wasmedgePlugin.dir/plugin.cpp.o
# FAILED: lib/plugin/CMakeFiles/wasmedgePlugin.dir/plugin.cpp.o
# ...
# In file included from /home/builder/.termux-build/wasmedge/src/lib/plugin/plugin.cpp:4:
# In file included from /home/builder/.termux-build/wasmedge/src/include/plugin/plugin.h:20:
# In file included from /home/builder/.termux-build/wasmedge/src/include/runtime/instance/module.h:24:
# /home/builder/.termux-build/wasmedge/src/include/runtime/instance/table.h:146:15: error: object of type
# 'std::__vector_base<WasmEdge::Variant<WasmEdge::UnknownRef, WasmEdge::FuncRef, WasmEdge::ExternRef>,
#  std::allocator<WasmEdge::Variant<WasmEdge::UnknownRef,
#  WasmEdge::FuncRef, WasmEdge::ExternRef>>>::value_type'
# (aka 'WasmEdge::Variant<WasmEdge::UnknownRef, WasmEdge::FuncRef, WasmEdge::ExternRef>')
# cannot be assigned because its copy assignment operator is implicitly deleted
#     Refs[Idx] = Val;
#               ^
# Both i686 and arm warning (0.10.1):
# /home/builder/.termux-build/wasmedge/src/lib/aot/compiler.cpp:1202:24: warning: unused variable 'VectorSize' [-Wunused-variable]
#         const uint32_t VectorSize = IsFloat ? 4 : 2;
#                        ^
# Upstream doesnt seem to support 32bit platforms well
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

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
