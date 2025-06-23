TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION=2.2.13
TERMUX_PKG_SRCURL=(
	https://github.com/denoland/deno/releases/download/v$TERMUX_PKG_VERSION/deno_src.tar.gz
	https://github.com/licy183/deno-snapshot/releases/download/v$TERMUX_PKG_VERSION/deno-snapshot-aarch64-linux-android-$TERMUX_PKG_VERSION.tar.bz2
	https://github.com/licy183/deno-snapshot/releases/download/v$TERMUX_PKG_VERSION/deno-snapshot-x86_64-linux-android-$TERMUX_PKG_VERSION.tar.bz2
)
TERMUX_PKG_SHA256=(
	ed6c40be562394aa72251c3bd77432374e328cf0024226daadaba1b3486c2a68
	e39aa39e6d7d4816b6b75de0380cf272e4d9b1454f70d270eb88b17bae1143a8
	210f7fb75039a2978d20d19a5ff05a601f4940626d019033dc29b7ca288c8040
)
TERMUX_PKG_DEPENDS="libffi, libsqlite, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true

# See https://github.com/denoland/deno/issues/2295#issuecomment-2329248010
TERMUX_PKG_EXCLUDED_ARCHES="i686, arm"

termux_step_get_source() {
	# XXX: Add version to the name of deno src tarball
	local _target_name=(
		"deno_src-$TERMUX_PKG_VERSION.tar.gz"
		"deno-snapshot-aarch64-linux-android-$TERMUX_PKG_VERSION.tar.bz2"
		"deno-snapshot-x86_64-linux-android-$TERMUX_PKG_VERSION.tar.bz2"
	)
	local _target_path=(
		"$TERMUX_PKG_SRCDIR"
		"$TERMUX_PKG_SRCDIR/deno-snapshot-aarch64-linux-android-$TERMUX_PKG_VERSION"
		"$TERMUX_PKG_SRCDIR/deno-snapshot-x86_64-linux-android-$TERMUX_PKG_VERSION"
	)
	local i=0
	for i in $(seq 0 $(( ${#TERMUX_PKG_SRCURL[@]}-1 ))); do
		local file="$TERMUX_PKG_CACHEDIR"/"${_target_name[$i]}"
		local path="${_target_path[$i]}"
		termux_download "${TERMUX_PKG_SRCURL[$i]}" "$file" "${TERMUX_PKG_SHA256[$i]}"
		mkdir -p "$path"
		tar xf "$file" -C "$path" --strip-components=1
	done
}

termux_step_pre_configure() {
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/deno_panic \
		! -wholename ./vendor/v8 \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/v8/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rusty-v8-search-files-with-target-suffix.diff

	patch --silent -p1 \
		-d ./vendor/deno_panic/ \
		< "$TERMUX_PKG_BUILDER_DIR"/deno-panic-dyn_slide.diff

	echo "" >> Cargo.toml
	echo "[patch.crates-io]" >> Cargo.toml
	echo "v8 = { path = \"./vendor/v8\" }" >> Cargo.toml
	echo "deno_panic = { path = \"./vendor/deno_panic\" }" >> Cargo.toml
}

__fetch_rusty_v8() {
	pushd "$TERMUX_PKG_SRCDIR"
	local v8_version=$(cargo info v8 | grep -e "^version:" | sed -n 's/^version:[[:space:]]*\([0-9.]*\).*/\1/p')
	if [ ! -d "$TERMUX_PKG_SRCDIR"/librusty_v8 ]; then
		rm -rf "$TERMUX_PKG_SRCDIR"/librusty_v8-tmp
		git init librusty_v8-tmp
		cd librusty_v8-tmp
		git remote add origin https://github.com/denoland/rusty_v8.git
		git fetch --depth=1 origin v"$v8_version"
		git reset --hard FETCH_HEAD
		git submodule update --init --recursive --depth=1
		local f
		for f in $(find "$TERMUX_PKG_BUILDER_DIR/jumbo-patches" -maxdepth 1 -type f -name *.patch | sort); do
			echo "Applying patch: $(basename $f)"
			patch --silent -p1 < "$f"
		done
		mv "$TERMUX_PKG_SRCDIR"/librusty_v8-tmp "$TERMUX_PKG_SRCDIR"/librusty_v8
	fi
	popd # "$TERMUX_PKG_SRCDIR"
}

__build_rusty_v8() {
	local __SRC_DIR="$TERMUX_PKG_SRCDIR"/librusty_v8
	if [ -f "$__SRC_DIR"/.built ]; then
		return
	fi
	pushd "$__SRC_DIR"

	termux_setup_ninja
	termux_setup_gn

	export EXTRA_GN_ARGS="
android32_ndk_api_level=$TERMUX_PKG_API_LEVEL
android64_ndk_api_level=$TERMUX_PKG_API_LEVEL
android_ndk_root=\"$NDK\"
android_ndk_version=\"$TERMUX_NDK_VERSION\"
use_jumbo_build=true
"

	if [ "$TERMUX_ARCH" = "arm" ]; then
		EXTRA_GN_ARGS+=" target_cpu = \"arm\""
		EXTRA_GN_ARGS+=" v8_target_cpu = \"arm\""
		EXTRA_GN_ARGS+=" arm_arch = \"armv7-a\""
		EXTRA_GN_ARGS+=" arm_float_abi = \"softfp\""
	fi

	# shellcheck disable=SC2155 # Ignore command exit-code
	export GN="$(command -v gn)"

	# Make build.rs happy
	ln -sf "$NDK" "$__SRC_DIR"/third_party/android_ndk

	BINDGEN_EXTRA_CLANG_ARGS="--target=$CCTERMUX_HOST_PLATFORM"
	BINDGEN_EXTRA_CLANG_ARGS+=" --sysroot=$__SRC_DIR/third_party/android_ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot"
	export BINDGEN_EXTRA_CLANG_ARGS
	local env_name=BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export "$env_name"="$BINDGEN_EXTRA_CLANG_ARGS"

	export V8_FROM_SOURCE=1
	# TODO: How to track the output of v8's build.rs without passing `-vv`
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release

	unset BINDGEN_EXTRA_CLANG_ARGS "$env_name" V8_FROM_SOURCE
	touch "$__SRC_DIR"/.built

	popd # "$__SRC_DIR"
}

__install_rusty_v8() {
	local __SRC_DIR="$TERMUX_PKG_SRCDIR"/librusty_v8
	install -Dm600 -t "${TERMUX_PREFIX}/include/librusty_v8" "$__SRC_DIR/target/${CARGO_TARGET_NAME}/release/gn_out/src_binding.rs"
	install -Dm600 -t "${TERMUX_PREFIX}/lib" "$__SRC_DIR/target/${CARGO_TARGET_NAME}/release/gn_out/obj/librusty_v8.a"
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/librusty-v8" "$__SRC_DIR/LICENSE"
	install -Dm600 -t "${TERMUX_PREFIX}/share/doc/librusty-v8" "$__SRC_DIR/v8/LICENSE.v8"
}

termux_step_configure() {
	termux_setup_rust

	# Fetch librusty-v8
	__fetch_rusty_v8
	# Build librusty-v8
	__build_rusty_v8
	# Install librusty-v8
	__install_rusty_v8
}

termux_step_make() {
	termux_setup_rust
	termux_setup_cmake
	termux_setup_protobuf

	local env_name=${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export RUSTY_V8_ARCHIVE_${env_name}="${TERMUX_PREFIX}/lib/librusty_v8.a"
	export RUSTY_V8_SRC_BINDING_PATH_${env_name}="${TERMUX_PREFIX}/include/librusty_v8/src_binding.rs"
	export DENO_SKIP_CROSS_BUILD_CHECK=1
	export DENO_PREBUILT_CLI_SNAPSHOT="$TERMUX_PKG_SRCDIR/deno-snapshot-$CARGO_TARGET_NAME-$TERMUX_PKG_VERSION/CLI_SNAPSHOT.bin"

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		export PKG_CONFIG_x86_64_unknown_linux_gnu=/usr/bin/pkg-config
		export PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig
	fi

	# ld.lld: error: undefined symbol: __clear_cache
	if [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		export CARGO_TARGET_${env_name}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/release/deno"
}
