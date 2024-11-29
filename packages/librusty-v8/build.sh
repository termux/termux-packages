TERMUX_PKG_HOMEPAGE=https://github.com/denoland/rusty_v8
TERMUX_PKG_DESCRIPTION="High quality Rust bindings to V8's C++ API"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=130.0.1
TERMUX_PKG_SRCURL=git+https://github.com/denoland/rusty_v8
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

termux_step_configure() {
	termux_setup_rust
	termux_setup_ninja
	termux_setup_gn

	export EXTRA_GN_ARGS="
android32_ndk_api_level=${TERMUX_PKG_API_LEVEL}
android64_ndk_api_level=${TERMUX_PKG_API_LEVEL}
android_ndk_root=\"${NDK}\"
android_ndk_version=\"${TERMUX_NDK_VERSION}\"
"

	if [[ "${TERMUX_ARCH}" == "arm" ]]; then
		EXTRA_GN_ARGS+=" target_cpu = \"arm\""
		EXTRA_GN_ARGS+=" v8_target_cpu = \"arm\""
		EXTRA_GN_ARGS+=" arm_arch = \"armv7-a\""
		EXTRA_GN_ARGS+=" arm_float_abi = \"softfp\""
	fi

	# shellcheck disable=SC2155 # Ignore command exit-code
	export GN="$(command -v gn)"

	# Make build.rs happy
	ln -sf "${NDK}" "${TERMUX_PKG_SRCDIR}"/third_party/android_ndk

	BINDGEN_EXTRA_CLANG_ARGS="--target=${CCTERMUX_HOST_PLATFORM}"
	BINDGEN_EXTRA_CLANG_ARGS+=" --sysroot=${TERMUX_PKG_SRCDIR}/third_party/android_ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
	export BINDGEN_EXTRA_CLANG_ARGS
	: "BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME@U}"
	: "${_//-/_}"
	export "$_"="${BINDGEN_EXTRA_CLANG_ARGS}"
}

termux_step_make() {
	export V8_FROM_SOURCE=1
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
	export PRINT_GN_ARGS="1"

	# patch for i686 and arm
	if [[ "${TERMUX_ARCH}" =~ i686|arm ]]; then
		patch "target/${CARGO_TARGET_NAME}/release/gn_out/src_binding.rs" "${TERMUX_PKG_BUILDER_SCRIPT}/fix-size-for-32-bit-archs.diff"
	fi
}

termux_step_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}/include/librusty_v8" "target/${CARGO_TARGET_NAME}/release/gn_out/src_binding.rs"
	install -Dm600 -t "${TERMUX_PREFIX}/lib" "target/${CARGO_TARGET_NAME}/release/gn_out/obj/librusty_v8.a"
}
