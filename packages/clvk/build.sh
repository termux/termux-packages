TERMUX_PKG_HOMEPAGE=https://github.com/kpet/clvk
TERMUX_PKG_DESCRIPTION="Experimental implementation of OpenCL on Vulkan"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=ad6d1b71dc6b351928b6c9e9d4d826e39fe2ea44
_COMMIT_DATE=20220806
_COMMIT_TIME=052514
# termux_pkg_upgrade_version edits TERMUX_PKG_VERSION wholly
TERMUX_PKG_VERSION="0.0.20220806gad6d1b71"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/kpet/clvk.git
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_BUILD_DEPENDS="vulkan-loader-android, vulkan-headers"
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_SUGGESTS="ocl-icd"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLLVM_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/llvm-tblgen
-DCLANG_TABLEGEN=$TERMUX_PKG_HOSTBUILD_DIR/bin/clang-tblgen
"

# https://github.com/kpet/clvk/blob/main/CMakeLists.txt

# clvk currently does not have proper versioning nor releases
# Use dates and commits as versioning for now
termux_pkg_auto_update() {
	local latest_commit
	latest_commit="$(curl -s https://api.github.com/repos/kpet/clvk/commits | jq .[].sha | head -1 | sed -e 's|\"||g')"

	if [ -z "$latest_commit" ]; then
		termux_error_exit "ERROR: Unable to get latest commit from upstream"
	fi

	if [ "$latest_commit" = "$_COMMIT" ]; then
		echo "INFO: No update needed. Already at version '$TERMUX_PKG_VERSION'."
		return 0
	fi

	local latest_commit_date_tz
	latest_commit_date_tz="$(curl -s https://api.github.com/repos/kpet/clvk/commits/$latest_commit | jq .commit.committer.date | sed -e 's|\"||g')"

	if [ -z "$latest_commit_date_tz" ]; then
		termux_error_exit "ERROR: Unable to get latest commit date info"
	fi

	local latest_commit_date="$(echo $latest_commit_date_tz | sed -e 's|\(.*\)T\(.*\)Z|\1|' -e 's|\-||g')"
	local latest_commit_time="$(echo $latest_commit_date_tz | sed -e 's|\(.*\)T\(.*\)Z|\2|' -e 's|\:||g')"
	local latest_version="0.0.${latest_commit_date}g${latest_commit:0:8}"

	# less likely to happen, not going to include time into an already long versioning
	if [ "$latest_commit_date" -eq "$_COMMIT_DATE" ] && [ "$latest_commit_time" -gt "$_COMMIT_TIME" ]; then
		if ! dpkg --compare-versions "$latest_version" gt "$TERMUX_PKG_VERSION"; then
			termux_error_exit "ERROR: Resulting latest version is not counted as update to the current version ($latest_version < $TERMUX_PKG_VERSION)"
		fi
	fi

	# unlikely to happen
	if [ "$latest_commit_date" -lt "$_COMMIT_DATE" ]; then
		termux_error_exit "ERROR: Upstream is older than current package version. Please report to upstream."
	elif [ "$latest_commit_date" -eq "$_COMMIT_DATE" ] && [ "$latest_commit_time" -lt "$_COMMIT_TIME" ]; then
		termux_error_exit "ERROR: Upstream is older than current package version. Please report to upstream."
	fi

	sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^_COMMIT=.*|_COMMIT=${latest_commit}|"
	sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^_COMMIT_DATE=.*|_COMMIT_DATE=${latest_commit_date}|"
	sed -i "${TERMUX_PKG_BUILDER_DIR}/build.sh" -e "s|^_COMMIT_TIME=.*|_COMMIT_TIME=${latest_commit_time}|"

	# maybe save a few ms as we already done version check
	termux_pkg_upgrade_version "$latest_version" --skip-version-check
}

# clvk prefers Khronos Vulkan Loader than the one come from NDK
# Sticking with NDK should expose more Vulkan limitations in Android (like below)
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+="
-DCLVK_VULKAN_IMPLEMENTATION=custom
-DVulkan_INCLUDE_DIRS=$TERMUX_PREFIX/include
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
	git fetch --unshallow
	git reset --hard ${_COMMIT}
	git submodule deinit --force --all
	git submodule update --init --recursive
	./external/clspv/utils/fetch_sources.py --deps llvm
}

termux_step_host_build() {
	termux_setup_cmake
	termux_setup_ninja

	cmake \
		-G Ninja \
		-S "$TERMUX_PKG_SRCDIR/external/clspv/third_party/llvm/llvm" \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_PROJECTS=clang
	cmake \
		--build "$TERMUX_PKG_HOSTBUILD_DIR" \
		-j "$TERMUX_MAKE_PROCESSES" \
		--target llvm-tblgen clang-tblgen
}

termux_step_pre_configure() {
	# from packages/libllvm/build.sh
	export LLVM_DEFAULT_TARGET_TRIPLE=${CCTERMUX_HOST_PLATFORM/-/-unknown-}
	export LLVM_TARGET_ARCH
	if [ "$TERMUX_ARCH" = arm ]; then
		LLVM_TARGET_ARCH=ARM
	elif [ "$TERMUX_ARCH" = aarch64 ]; then
		LLVM_TARGET_ARCH=AArch64
	elif [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = x86_64 ]; then
		LLVM_TARGET_ARCH=X86
	else
		termux_error_exit "Invalid arch: $TERMUX_ARCH"
	fi

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGET_ARCH=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_TARGETS_TO_BUILD=$LLVM_TARGET_ARCH"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DLLVM_HOST_TRIPLE=$LLVM_DEFAULT_TARGET_TRIPLE"

	# TERMUX_DEBUG_BUILD doesnt really have somewhere in between
	#TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DCMAKE_BUILD_TYPE=RelWithDebInfo"
	#export STRIP=:
}

termux_step_make_install() {
	# clvk has a very basic install rule
	install -Dm644 "$TERMUX_PKG_BUILDDIR/libOpenCL.so" "$TERMUX_PREFIX/lib/clvk/libOpenCL.so"

	echo "$TERMUX_PREFIX/lib/clvk/libOpenCL.so" > "$TERMUX_PKG_TMPDIR/clvk.icd"
	install -Dm644 "$TERMUX_PKG_TMPDIR/clvk.icd" "$TERMUX_PREFIX/etc/OpenCL/vendors/clvk.icd"
}
