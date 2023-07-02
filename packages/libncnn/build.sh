TERMUX_PKG_HOMEPAGE=https://github.com/Tencent/ncnn
TERMUX_PKG_DESCRIPTION="A high-performance neural network inference framework optimized for the mobile platform"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=4b97730b0d033b4dc2a790e5c35745e0dbf51569
TERMUX_PKG_VERSION="20230627"
TERMUX_PKG_SRCURL=git+https://github.com/Tencent/ncnn
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="abseil-cpp, glslang, libc++, vulkan-loader"
TERMUX_PKG_BUILD_DEPENDS="protobuf-static, python, vulkan-headers, vulkan-loader-android"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel, pybind11"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_BUILD_TYPE=Release
-DNCNN_VULKAN=ON
-DVulkan_LIBRARY=${TERMUX_PREFIX}/lib/libvulkan.so
-DVulkan_INCLUDE_DIRS=${TERMUX_PREFIX}/include
-DNCNN_PLATFORM_API=OFF
-DNCNN_BUILD_EXAMPLES=OFF
-DNCNN_DISABLE_RTTI=OFF
-DNCNN_BUILD_BENCHMARK=OFF
-DNCNN_SIMPLEOCV=ON
-DNCNN_SYSTEM_GLSLANG=ON
-DNCNN_OPENMP=ON
-DNCNN_PYTHON=ON
-DCMAKE_EXE_LINKER_FLAGS=-ldl
"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout "${_COMMIT}"
	git submodule update --init --recursive
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
}
