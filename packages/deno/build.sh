TERMUX_PKG_HOMEPAGE=https://deno.land/
TERMUX_PKG_DESCRIPTION="A modern runtime for JavaScript and TypeScript"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@licy183"
TERMUX_PKG_VERSION="1:2.6.10"
TERMUX_PKG_SRCURL=https://github.com/denoland/deno/releases/download/v${TERMUX_PKG_VERSION:2}/deno_src.tar.gz
TERMUX_PKG_SHA256=9d36d89e11b61626d732d71fd5a2b83afba06d02373f1fa8daffff3a0addf936
TERMUX_PKG_DEPENDS="libandroid-stub, libffi, libsqlite, zlib"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

# See https://github.com/denoland/deno/issues/2295#issuecomment-2329248010
TERMUX_PKG_EXCLUDED_ARCHES="i686, arm"

termux_step_get_source() {
	# XXX: Add version to the name of deno src tarball
	local file="$TERMUX_PKG_CACHEDIR/deno_src-${TERMUX_PKG_VERSION:2}.tar.gz"
	termux_download "${TERMUX_PKG_SRCURL}" "$file" "${TERMUX_PKG_SHA256}"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar xf "$file" -C "$TERMUX_PKG_SRCDIR" --strip-components=1
}

termux_step_pre_configure() {
	# Backup source of deno_snapshots
	mv "$TERMUX_PKG_SRCDIR"/cli/snapshot "$TERMUX_PKG_TMPDIR"/snapshot.orig
	mkdir -p "$TERMUX_PKG_SRCDIR"/cli/snapshot
	cp -Rf "$TERMUX_PKG_TMPDIR"/snapshot.orig/* "$TERMUX_PKG_SRCDIR"/cli/snapshot/

	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/deno_panic \
		! -wholename ./vendor/v8 \
		! -wholename ./vendor/cmake \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/v8/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rusty-v8-search-files-with-target-suffix.diff

	patch --silent -p1 \
		-d ./vendor/deno_panic/ \
		< "$TERMUX_PKG_BUILDER_DIR"/deno-panic-dyn_slide.diff

	patch --silent -p1 \
		-d ./vendor/cmake/ \
		< "$TERMUX_PKG_BUILDER_DIR"/cmake-pass-cmake-policy-version-minimum.diff

	echo "" >> Cargo.toml
	echo "[patch.crates-io]" >> Cargo.toml
	echo "v8 = { path = \"./vendor/v8\" }" >> Cargo.toml
	echo "deno_panic = { path = \"./vendor/deno_panic\" }" >> Cargo.toml
	echo "cmake = { path = \"./vendor/cmake\" }" >> Cargo.toml
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
		for f in $(find "$TERMUX_PKG_BUILDER_DIR/v8-patches" -maxdepth 1 -type f -name *.patch | sort); do
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
android_ndk_api_level=$TERMUX_PKG_API_LEVEL
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
	termux_setup_ninja
	termux_setup_protobuf

	export CMAKE_POLICY_VERSION_MINIMUM=3.5
	export TARGET_CMAKE_TOOLCHAIN_FILE="$TERMUX_PKG_TMPDIR/android.toolchain.cmake"
	cat <<- EOL > "$TARGET_CMAKE_TOOLCHAIN_FILE"
	set(CMAKE_ASM_FLAGS "\${CMAKE_ASM_FLAGS} --target=${CCTERMUX_HOST_PLATFORM}")
	set(CMAKE_C_FLAGS "\${CMAKE_C_FLAGS} --target=${CCTERMUX_HOST_PLATFORM} ${CFLAGS}")
	set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} --target=${CCTERMUX_HOST_PLATFORM} ${CXXFLAGS}")
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
	EOL

	cargo install --force --locked bindgen-cli
	BINDGEN_EXTRA_CLANG_ARGS="--target=$CCTERMUX_HOST_PLATFORM"
	BINDGEN_EXTRA_CLANG_ARGS+=" --sysroot=${TERMUX_STANDALONE_TOOLCHAIN}/sysroot"
	BINDGEN_EXTRA_CLANG_ARGS+=" -I$TERMUX_PREFIX/include"
	BINDGEN_EXTRA_CLANG_ARGS+=" -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/include/c++/v1"
	BINDGEN_EXTRA_CLANG_ARGS+=" -isystem ${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/include/${TERMUX_ARCH}-linux-android"
	export BINDGEN_EXTRA_CLANG_ARGS
	local env_name=BINDGEN_EXTRA_CLANG_ARGS_${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export "$env_name"="$BINDGEN_EXTRA_CLANG_ARGS"

	local env_name=${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export RUSTY_V8_ARCHIVE_${env_name}="${TERMUX_PREFIX}/lib/librusty_v8.a"
	export RUSTY_V8_SRC_BINDING_PATH_${env_name}="${TERMUX_PREFIX}/include/librusty_v8/src_binding.rs"
	export DENO_SKIP_CROSS_BUILD_CHECK=1

	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		export PKG_CONFIG_x86_64_unknown_linux_gnu=/usr/bin/pkg-config
		export PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig
	fi

	# ld.lld: error: undefined symbol: __clear_cache
	if [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		export CARGO_TARGET_${env_name}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	local _release_opt="--release"
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		_release_opt=
	fi

	# Prepare source to build cli snapshot generator
	rm -rf "$TERMUX_PKG_SRCDIR"/cli/snapshot/*
	mkdir -p "$TERMUX_PKG_SRCDIR"/cli/snapshot/src
	cp -f "$TERMUX_PKG_TMPDIR"/snapshot.orig/Cargo.toml "$TERMUX_PKG_SRCDIR"/cli/snapshot/
	cp -f "$TERMUX_PKG_TMPDIR"/snapshot.orig/build.rs "$TERMUX_PKG_SRCDIR"/cli/snapshot/src/main.rs
	cp -f "$TERMUX_PKG_TMPDIR"/snapshot.orig/shared.rs "$TERMUX_PKG_SRCDIR"/cli/snapshot/src/shared.rs
	patch --silent -p1 \
		-d "$TERMUX_PKG_SRCDIR" \
		< "$TERMUX_PKG_BUILDER_DIR"/deno-snapshot-build-generator.diff

	# Build cli snapshot generator
	cargo build ${_release_opt} \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}"  \
		--manifest-path ./cli/snapshot/Cargo.toml

	# Generate cli snapshot
	local _deno_prebuilt_snapshot_dir="$TERMUX_PKG_TMPDIR/deno-snapshot-$CARGO_TARGET_NAME-${TERMUX_PKG_VERSION:2}"
	mkdir -p "$_deno_prebuilt_snapshot_dir"
	termux_setup_proot
	termux-proot-run env LD_PRELOAD= LD_LIBRARY_PATH= \
		OUT_DIR="$_deno_prebuilt_snapshot_dir" TARGET="$CARGO_TARGET_NAME" \
		"$TERMUX_PKG_SRCDIR"/target/$CARGO_TARGET_NAME/release/deno_snapshots

	# Recover source
	rm -rf "$TERMUX_PKG_SRCDIR"/cli/snapshot/*
	cp -Rf "$TERMUX_PKG_TMPDIR"/snapshot.orig/* "$TERMUX_PKG_SRCDIR"/cli/snapshot/

	# Build deno
	export DENO_PREBUILT_CLI_SNAPSHOT="$_deno_prebuilt_snapshot_dir/CLI_SNAPSHOT.bin"
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" ${_release_opt}
}

termux_step_make_install() {
	local _folder="release"
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		_folder="debug"
	fi
	install -Dm700 -t "${TERMUX_PREFIX}/bin" "target/${CARGO_TARGET_NAME}/${_folder}/deno"
}
