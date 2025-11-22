TERMUX_PKG_HOMEPAGE=https://github.com/ggml-org/llama.cpp
TERMUX_PKG_DESCRIPTION="LLM inference in C/C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="0.0.0-b7130"
TERMUX_PKG_SRCURL=https://github.com/ggml-org/llama.cpp/archive/refs/tags/${TERMUX_PKG_VERSION#*-}.tar.gz
TERMUX_PKG_SHA256=35d88d0f9435c5b147163941bae3c096dd97e0f329bc743f5cd604c36e9756c5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++, libcurl"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, opencl-headers, ocl-icd"
TERMUX_PKG_SUGGESTS="llama-cpp-backend-vulkan, llama-cpp-backend-opencl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DLLAMA_BUILD_TESTS=OFF
-DLLAMA_CURL=ON
-DGGML_BACKEND_DL=ON
-DGGML_OPENMP=OFF
-DGGML_VULKAN=ON
-DGGML_VULKAN_SHADERS_GEN_TOOLCHAIN=$TERMUX_PKG_BUILDER_DIR/host-toolchain.cmake
-DGGML_OPENCL=ON
"

# XXX: llama.cpp uses `int64_t`, but on 32-bit Android `size_t` is `int32_t`.
# XXX: I don't think it will work if we simply casting it.
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_pkg_auto_update() {
	local latest_tag
	latest_tag="$(
		termux_github_api_get_tag "${TERMUX_PKG_SRCURL}" "${TERMUX_PKG_UPDATE_TAG_TYPE}"
	)"

	if [[ -z "${latest_tag}" ]]; then
		termux_error_exit "Unable to get tag from ${TERMUX_PKG_SRCURL}"
	fi
	termux_pkg_upgrade_version "0.0.0-${latest_tag}"
}

termux_step_pre_configure() {
	export PATH="$NDK/shader-tools/linux-x86_64:$PATH"

	local _libvulkan=vulkan
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" && "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
		_libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/28/libvulkan.so"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARY=${_libvulkan}"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/lib
	cp -f "$TERMUX_PKG_BUILDDIR"/bin/libggml-cpu.so "$TERMUX_PREFIX"/lib/
	cp -f "$TERMUX_PKG_BUILDDIR"/bin/libggml-opencl.so "$TERMUX_PREFIX"/lib/
	cp -f "$TERMUX_PKG_BUILDDIR"/bin/libggml-vulkan.so "$TERMUX_PREFIX"/lib/
}
