TERMUX_PKG_HOMEPAGE=https://github.com/ggml-org/whisper.cpp
TERMUX_PKG_DESCRIPTION="Port of OpenAI's Whisper model in C/C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
# Remove 'v' prefix - Debian package versions must start with a digit
TERMUX_PKG_VERSION="1.8.3"
# Use the version WITH 'v' prefix for the GitHub tag
TERMUX_PKG_SRCURL=https://github.com/ggml-org/whisper.cpp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=870ba21409cdf66697dc4db15ebdb13bc67037d76c7cc63756c81471d8f1731a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libcurl, sdl2, ffmpeg"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers, opencl-headers, ocl-icd, shaderc, libopenblas, glslang"
TERMUX_PKG_SUGGESTS="llama-cpp-backend-vulkan, llama-cpp-backend-opencl"
TERMUX_PKG_CONFLICTS="llama-cpp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DWHISPER_BUILD_TESTS=OFF
-DWHISPER_BUILD_SERVER=OFF
-DWHISPER_BUILD_EXAMPLES=ON
-DWHISPER_CURL=ON
-DWHISPER_SDL2=ON
-DWHISPER_FFMPEG=ON
-DWHISPER_SANITIZE_THREAD=OFF
-DWHISPER_SANITIZE_ADDRESS=OFF
-DGGML_BACKEND_DL=ON
-DGGML_OPENMP=OFF
-DGGML_BLAS=ON
-DGGML_VULKAN=ON
-DGGML_VULKAN_SHADERS_GEN_TOOLCHAIN=$TERMUX_PKG_BUILDER_DIR/host-toolchain.cmake
-DGGML_OPENCL=ON
"

TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"

termux_step_pre_configure() {
	export PATH="$NDK/shader-tools/linux-x86_64:$PATH"
	LDFLAGS+=" -landroid-spawn"

	# Add -MD flag to glslc for dependency generation
	export GGML_GLSLC_ARGS="-MD"

	# Use prefix path for on-device builds, sysroot for cross-compilation
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then
		local _libvulkan="${TERMUX_PREFIX}/lib/libvulkan.so"
	else
		# Cross-compilation: use sysroot, with API level 28+ for older targets
		if [[ "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
			local _libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/28/libvulkan.so"
		else
			local _libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/${TERMUX_PKG_API_LEVEL}/libvulkan.so"
		fi
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARY=${_libvulkan}"

	# Force SDL2 detection
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSDL2_INCLUDE_DIR=${TERMUX_PREFIX}/include/SDL2"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSDL2_LIBRARY=${TERMUX_PREFIX}/lib/libSDL2.so"

	# Force FFmpeg detection - set paths for all ffmpeg components
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVCODEC_INCLUDE_DIR=${TERMUX_PREFIX}/include"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVCODEC_LIBRARY=${TERMUX_PREFIX}/lib/libavcodec.so"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVFORMAT_INCLUDE_DIR=${TERMUX_PREFIX}/include"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVFORMAT_LIBRARY=${TERMUX_PREFIX}/lib/libavformat.so"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVUTIL_INCLUDE_DIR=${TERMUX_PREFIX}/include"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DAVUTIL_LIBRARY=${TERMUX_PREFIX}/lib/libavutil.so"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSWRESAMPLE_INCLUDE_DIR=${TERMUX_PREFIX}/include"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DSWRESAMPLE_LIBRARY=${TERMUX_PREFIX}/lib/libswresample.so"

	# Force link flags
	LDFLAGS+=" -lSDL2 -lavcodec -lavformat -lavutil -lswresample"
}
