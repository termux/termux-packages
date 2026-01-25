TERMUX_PKG_HOMEPAGE=https://ollama.com/
TERMUX_PKG_DESCRIPTION="Get up and running with large language models"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.1"
TERMUX_PKG_SRCURL=git+https://github.com/ollama/ollama
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="vulkan-headers"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_SHARED_LIBS=ON
-DLLAMA_BUILD_TESTS=OFF
-DGGML_BACKEND_DL=ON
-DGGML_CPU_ALL_VARIANTS=ON
-DGGML_OPENMP=OFF
-DGGML_VULKAN=ON
-DGGML_VULKAN_SHADERS_GEN_TOOLCHAIN=$TERMUX_PKG_BUILDER_DIR/host-toolchain.cmake
"

termux_step_pre_configure() {
	export PATH="$NDK/shader-tools/linux-x86_64:$PATH"

	local _libvulkan=vulkan
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" && "${TERMUX_PKG_API_LEVEL}" -lt 28 ]]; then
		_libvulkan="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/28/libvulkan.so"
	fi
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DVulkan_LIBRARY=${_libvulkan}"
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	termux_setup_golang

	go build -trimpath -ldflags="-w -s -X=github.com/ollama/ollama/version.Version=$TERMUX_PKG_VERSION -X=github.com/ollama/ollama/server.mode=release"
	install -Dm700 ollama $TERMUX_PREFIX/bin/

	mkdir -p $TERMUX_PREFIX/lib/ollama
	cp -fv $TERMUX_PKG_BUILDDIR/lib/ollama/* $TERMUX_PREFIX/lib/ollama/
}
