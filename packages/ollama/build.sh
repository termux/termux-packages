TERMUX_PKG_HOMEPAGE=https://ollama.com/
TERMUX_PKG_DESCRIPTION="Get up and running with large language models"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.30.10"
TERMUX_PKG_SRCURL=git+https://github.com/ollama/ollama
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++"
TERMUX_PKG_BUILD_DEPENDS="spirv-headers, vulkan-headers"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DFETCHCONTENT_SOURCE_DIR_LLAMA_CPP=$TERMUX_PKG_SRCDIR/llama-cpp-source
-DGGML_BACKEND_DL=ON
-DGGML_CPU_ALL_VARIANTS=ON
-DGGML_OPENMP=OFF
-DGGML_VULKAN_SHADERS_GEN_TOOLCHAIN=$TERMUX_PKG_BUILDER_DIR/host-toolchain.cmake
-DLLAMA_BUILD_TESTS=OFF
-DOLLAMA_LLAMA_BACKENDS=vulkan
-DOLLAMA_VERSION=$TERMUX_PKG_VERSION
"

termux_step_post_get_source() {
	# Fetch the source code of llama.cpp
	local _llama_cpp_version=$(cat LLAMA_CPP_VERSION)
	local _llama_cpp_tmp_checkout="$TERMUX_PKG_CACHEDIR/llama-cpp-tmp-checkout"
	local _llama_cpp_tmp_checkout_version="$TERMUX_PKG_CACHEDIR/llama-cpp-tmp-checkout-version"
	if [[ ! -f $_llama_cpp_tmp_checkout_version || "$(< "$_llama_cpp_tmp_checkout_version")" != "$_llama_cpp_version" ]]; then
		rm -rf "$_llama_cpp_tmp_checkout"
		git clone \
			--branch "$_llama_cpp_version" \
			"https://github.com/ggml-org/llama.cpp" \
			--depth=1 \
			"$_llama_cpp_tmp_checkout"
		echo "$_llama_cpp_version" > "$_llama_cpp_tmp_checkout_version"
	fi
	rm -rf "$TERMUX_PKG_SRCDIR/llama-cpp-source"
	cp -Rf "$_llama_cpp_tmp_checkout" "$TERMUX_PKG_SRCDIR/llama-cpp-source"
}

termux_step_configure() {
	termux_setup_golang
	termux_setup_cmake
	termux_setup_ninja

	export PATH="$NDK/shader-tools/linux-x86_64:$PATH"
	LDFLAGS+=" -landroid-spawn"

	local _libvulkan=vulkan
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" && "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
		_libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/28/libvulkan.so"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARY=${_libvulkan}"

	export TARGET_CMAKE_TOOLCHAIN_FILE="$TERMUX_PKG_TMPDIR/android.toolchain.cmake"
	cat <<- EOL > "$TARGET_CMAKE_TOOLCHAIN_FILE"
	set(CMAKE_ASM_FLAGS "\${CMAKE_ASM_FLAGS} --target=${CCTERMUX_HOST_PLATFORM}")
	set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} --target=${CCTERMUX_HOST_PLATFORM} ${CPPFLAGS} ${CFLAGS}")
	set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} --target=${CCTERMUX_HOST_PLATFORM} ${CPPFLAGS} ${CXXFLAGS}")
	set(CMAKE_C_COMPILER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${CC}")
	set(CMAKE_CXX_COMPILER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${CXX}")
	set(CMAKE_AR "$(command -v ${AR})")
	set(CMAKE_RANLIB "$(command -v ${RANLIB})")
	set(CMAKE_STRIP "$(command -v ${STRIP})")
	set(CMAKE_FIND_ROOT_PATH "${TERMUX_PREFIX}")
	set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM "NEVER")
	set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE "ONLY")
	set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY "ONLY")
	set(CMAKE_SKIP_INSTALL_RPATH "ON")
	set(CMAKE_USE_SYSTEM_LIBRARIES "True")
	set(CMAKE_CROSSCOMPILING "True")
	set(CMAKE_LINKER "${TERMUX_STANDALONE_TOOLCHAIN}/bin/${LD} ${LDFLAGS}")
	set(CMAKE_SYSTEM_NAME "Android")
	set(CMAKE_SYSTEM_VERSION "${TERMUX_PKG_API_LEVEL}")
	set(CMAKE_SYSTEM_PROCESSOR "${TERMUX_ARCH}")
	set(CMAKE_ANDROID_STANDALONE_TOOLCHAIN "${TERMUX_STANDALONE_TOOLCHAIN}")
	set(Vulkan_LIBRARY "${_libvulkan}")
	EOL

	termux_step_configure_cmake

	export CMAKE_BUILD_PARALLEL_LEVEL="$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_golang

	go build -trimpath -ldflags="-w -s -X=github.com/ollama/ollama/version.Version=$TERMUX_PKG_VERSION -X=github.com/ollama/ollama/server.mode=release"
	install -Dm700 ollama $TERMUX_PREFIX/bin/

	rm -rf $TERMUX_PREFIX/lib/ollama
	mkdir -p $TERMUX_PREFIX/lib/ollama
	cp -frv $TERMUX_PKG_BUILDDIR/lib/ollama/* $TERMUX_PREFIX/lib/ollama/
}
