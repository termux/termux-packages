TERMUX_PKG_HOMEPAGE=https://github.com/kpet/clvk
TERMUX_PKG_DESCRIPTION="Experimental implementation of OpenCL on Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.20210829
TERMUX_PKG_REVISION=1
_COMMIT=2797e13ee3b03cbc97bc2afa3e99fc35d6a0c831
TERMUX_PKG_SRCURL=https://github.com/kpet/clvk.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_DEPENDS="vulkan-loader-android"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_SUGGESTS="ocl-icd"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
"

# clvk currently does not have proper versioning nor releases
# Use dates and commits as versioning for now

# clvk prefers Khronos Vulkan Loader than the one come from NDK
# Sticking with NDK should expose more Vulkan limitations in Android (like below)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
-DCLVK_VULKAN_IMPLEMENTATION=custom
-DVulkan_INCLUDE_DIRS=$TERMUX_PKG_SRCDIR/external/Vulkan-Headers/include
-DVulkan_LIBRARIES=vulkan
"

# clvk build test fail when linking with API 24 libvulkan.so
# clvk likely wont work on Android versions older than Android 9 (API 28)
#
# [1877/1888] Linking CXX executable api_tests
# FAILED: api_tests
# ...
# libOpenCL.so: error: undefined reference to 'vkGetPhysicalDeviceFeatures2'
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCLVK_BUILD_TESTS=OFF"

# clvk libOpenCL.so has a hardcoded path clspv bin at build time
# clvk cant automatically find clspv from PATH env var
# and rely on CLVK_CLSPV_BIN env var
# Use CLVK_CLSPV_ONLINE_COMPILER=1 to combine clspv with clvk
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCLVK_CLSPV_ONLINE_COMPILER=1"

termux_step_post_get_source() {
	git pull
	git reset --hard ${_COMMIT}
	git submodule foreach --recursive git reset --hard
	./external/clspv/utils/fetch_sources.py --deps llvm
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-DLLVM_ENABLE_PROJECTS='clang' \
		"$TERMUX_PKG_SRCDIR/external/clspv/third_party/llvm/llvm"
	cmake \
		--build "$TERMUX_PKG_HOSTBUILD_DIR" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target llvm-tblgen clang-tblgen
}

termux_step_pre_configure() {
	# from packages/libllvm/build.sh
	export LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	export LLVM_TARGET_ARCH
	if [ $TERMUX_ARCH = "arm" ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ $TERMUX_ARCH = "aarch64" ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ $TERMUX_ARCH = "i686" ] || [ $TERMUX_ARCH = "x86_64" ]; then
		LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGETS_TO_BUILD=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"
}

termux_step_make_install() {
	# clvk has a very basic install rule
	install -Dm644 "$TERMUX_PKG_BUILDDIR/libOpenCL.so" "$TERMUX_PREFIX/lib/clvk/libOpenCL.so"

	echo "$TERMUX_PREFIX/lib/clvk/libOpenCL.so" > "$TERMUX_PKG_TMPDIR/clvk.icd"
	install -Dm644 "$TERMUX_PKG_TMPDIR/clvk.icd" "$TERMUX_PREFIX/etc/OpenCL/vendors/clvk.icd"
}
