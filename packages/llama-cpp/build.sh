TERMUX_PKG_HOMEPAGE=https://github.com/ggml-org/llama.cpp
TERMUX_PKG_DESCRIPTION="LLM inference in C/C++"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="0.0.0-b7898"
TERMUX_PKG_SRCURL=https://github.com/ggml-org/llama.cpp/archive/refs/tags/${TERMUX_PKG_VERSION#*-}.tar.gz
TERMUX_PKG_SHA256=0804a677f85e49323901ea1be557a65b5a052cae8bc6091dd81fd115efed347c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-spawn, libc++, libcurl"
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

# This auto update function throttles the update frequency
# of the package to set `$update_interval`, this is useful
# for packages that make very frequent tags like `jackett`
# or `llama-cpp` to not spam the commit history, CI and repos.
termux_pkg_auto_update() {
	local origin_url last_autoupdate
	# Throttle auto updates to once every 2 weeks.
	local update_interval="$((14 * 86400))"

	# Get the git history
	if origin_url="$(git config --get remote.origin.url)"; then
		git fetch --quiet "${origin_url}" || {
			echo "WARN: Unable to fetch '${origin_url}'"
			echo "WARN: Skipping auto update for '$TERMUX_PKG_NAME'"
			return
		}
	fi

	# When was `llama-cpp` last autoupdated? (Unix epoch timestamp)
	last_autoupdate="$(
		git log \
		--author="Termux Github Actions <contact@termux.dev>" \
		-n1 \
		--pretty=format:%at \
		-- "$TERMUX_PKG_BUILDER_DIR/build.sh"
	)"


	if (( last_autoupdate > EPOCHSECONDS - update_interval )); then
		local t days hrs mins secs
		(( t = EPOCHSECONDS - last_autoupdate, days = t/86400, t %= 86400, secs= t%60, t /= 60, mins = t%60, hrs = t/60 ))

		printf 'INFO: Last updated %dd%dh%02dm%02ds ago.\n' "$days" "$hrs" "$mins" "$secs"
		printf 'INFO: Which is less than the desired %sd minimum update interval.\n' "$(( update_interval / 86400 ))"
		return
	fi

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
	LDFLAGS+=" -landroid-spawn"

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
