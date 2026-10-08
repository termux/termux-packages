TERMUX_PKG_HOMEPAGE=https://github.com/openai/codex
TERMUX_PKG_DESCRIPTION="Lightweight coding agent that runs in your terminal"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_LICENSE_FILE="../LICENSE, ../NOTICE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.159.3"
TERMUX_PKG_SRCURL="https://github.com/openai/codex/archive/refs/tags/rust-v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7a13f939c8b5ea4e5fb1434f0b4a5ea3f4c85b22a4782818cb28a43ed0deac58
TERMUX_PKG_DEPENDS="git, libc++, openssl"
TERMUX_PKG_RECOMMENDS="ripgrep"
TERMUX_PKG_BUILD_IN_SRC=true
# rusty-v8 doesn't support them
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/rust-v//'

termux_step_pre_configure() {
	termux_setup_rust

	cd codex-rs

	# Upstream pins rust 1.95.0, which predates std's Android file-locking
	# (rust-lang/rust#157038, in 1.98+). Use the toolchain set up by
	# termux_setup_rust instead.
	rm -f rust-toolchain.toml rust-toolchain

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		! -wholename ./vendor/v8 \
		-exec rm -rf '{}' \;

	patch --silent -p1 \
		-d ./vendor/cc/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rust-cc-do-not-concatenate-all-the-CFLAGS.diff

	patch --silent -p1 \
		-d ./vendor/cc/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rust-cc-allow-warnings.diff

	patch --silent -p1 \
		-d ./vendor/v8/ \
		< "$TERMUX_PKG_BUILDER_DIR"/rusty-v8-search-files-with-target-suffix.diff

	sed -i '/\[patch.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
	sed -i '/\[patch.crates-io\]/a v8 = { path = "./vendor/v8" }' Cargo.toml
}

__fetch_rusty_v8() {
	pushd "$TERMUX_PKG_SRCDIR"
	# Take the exact `v8` crate version locked in Cargo.lock, so that rusty_v8
	# sources always match what codex links against.
	local v8_version
	v8_version=$(cargo info v8 2>/dev/null | sed -n 's/^version: \([^ ]*\).*/\1/p')
	if [[ -z "$v8_version" ]]; then
		termux_error_exit "Failed to detect the locked v8 crate version via cargo info"
	fi
	if [ ! -d "$TERMUX_PKG_SRCDIR"/librusty_v8 ]; then
		rm -rf "$TERMUX_PKG_SRCDIR"/librusty_v8-tmp
		git init librusty_v8-tmp
		cd librusty_v8-tmp
		git remote add origin https://github.com/denoland/rusty_v8.git
		git fetch --depth=1 origin v"$v8_version"
		git reset --hard FETCH_HEAD
		# googlesource.com occasionally returns HTTP 503, so retry (resumable).
		local attempt
		for attempt in 1 2 3 4 5; do
			git submodule update --init --recursive --depth=1 && break
			if [ "$attempt" = 5 ]; then
				termux_error_exit "Failed to fetch v8 submodules after $attempt attempts"
			fi
			echo "Submodule fetch failed (attempt $attempt/5), retrying in 30s..."
			sleep 30
		done
		local f
		for f in $(find "$TERMUX_PKG_BUILDER_DIR/v8-patches" -maxdepth 1 -type f -name '*.patch' | sort); do
			echo "Applying patch: $(basename "$f")"
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

	# gn.googlesource.com occasionally returns HTTP 503. Under `set -e` a failed
	# termux_download aborts the build, so call termux_setup_gn with `|| true`,
	# then check that gn exists and retry with a clean cache if not.
	local gn_attempt
	for gn_attempt in 1 2 3 4 5; do
		termux_setup_gn || true
		if command -v gn > /dev/null; then
			break
		fi
		if [ "$gn_attempt" = 5 ]; then
			termux_error_exit "Failed to setup gn after $gn_attempt attempts"
		fi
		echo "gn setup failed (attempt $gn_attempt/5), retrying in 60s..."
		rm -rf "$TERMUX_COMMON_CACHEDIR"/gn-* "$TERMUX_COMMON_CACHEDIR"/gn_*.tar.gz
		sleep 60
	done

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
	export CARGO_FEATURE_SIMDUTF=1
	# TODO: How to track the output of v8's build.rs without passing `-vv`
	cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --target "${CARGO_TARGET_NAME}" --release

	unset BINDGEN_EXTRA_CLANG_ARGS "$env_name" V8_FROM_SOURCE
	touch "$__SRC_DIR"/.built

	popd # "$__SRC_DIR"
}

__install_rusty_v8() {
	local __SRC_DIR="$TERMUX_PKG_SRCDIR"/librusty_v8
	local _prefix="${TERMUX_PKG_TMPDIR}/rusty_v8_prefix"
	mkdir -p "${_prefix}"
	install -Dm600 -t "${_prefix}/include/librusty_v8" "$__SRC_DIR/target/${CARGO_TARGET_NAME}/release/gn_out/src_binding.rs"
	install -Dm600 -t "${_prefix}/lib" "$__SRC_DIR/target/${CARGO_TARGET_NAME}/release/gn_out/obj/librusty_v8.a"
}

termux_step_configure() {
	TERMUX_PKG_SRCDIR+="/codex-rs"
	TERMUX_PKG_BUILDDIR+="/codex-rs"
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

	local env_name=${CARGO_TARGET_NAME@U}
	env_name=${env_name//-/_}
	export RUSTY_V8_ARCHIVE_${env_name}="${TERMUX_PKG_TMPDIR}/rusty_v8_prefix/lib/librusty_v8.a"
	export RUSTY_V8_SRC_BINDING_PATH_${env_name}="${TERMUX_PKG_TMPDIR}/rusty_v8_prefix/include/librusty_v8/src_binding.rs"

	# ld.lld: error: undefined symbol: __clear_cache
	if [[ "${TERMUX_ARCH}" == "aarch64" ]]; then
		export CARGO_TARGET_${env_name}_RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
	fi

	local _release_opt="--release"
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		_release_opt=
	fi

	cargo build \
		-p codex-cli \
		--bin codex \
		${_release_opt} \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME

	# codex runs shell commands and writes files through this helper, which it
	# looks up next to the `codex` executable.
	cargo build \
		-p codex-code-mode-host \
		--bin codex-code-mode-host \
		${_release_opt} \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME
}

termux_step_make_install() {
	local _folder="release"
	if [ "$TERMUX_DEBUG_BUILD" = "true" ]; then
		_folder="debug"
	fi

	install -Dm700 -t $TERMUX_PREFIX/bin \
		target/${CARGO_TARGET_NAME}/${_folder}/codex \
		target/${CARGO_TARGET_NAME}/${_folder}/codex-code-mode-host

	rm -rf $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp -Rfv ../docs/* $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}
