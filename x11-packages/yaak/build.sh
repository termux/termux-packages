TERMUX_PKG_HOMEPAGE=https://yaak.app/
TERMUX_PKG_DESCRIPTION="Fast, privacy-first desktop API client for REST, GraphQL, SSE, WebSocket and gRPC"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2026.8.1"
TERMUX_PKG_SRCURL="https://github.com/mountain-loop/yaak/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=58c5b659e5eb565fa069009740dd7493ff9204ef8f62223c75afb07a7a5de3fe
TERMUX_PKG_AUTO_UPDATE=true

# Plugins run via Node.js at runtime
TERMUX_PKG_DEPENDS="gtk3, libx11, nodejs|nodejs-lts, openssl, webkit2gtk-4.1"

TERMUX_PKG_EXCLUDED_ARCHES="i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HAS_DEBUG=false
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_ninja
	termux_setup_rust
	termux_setup_nodejs
	termux_setup_protobuf

	# sysproxy 0.3.0 only builds get/set_system_proxy() for linux/macos/windows;
	# its linux backend just shells out to gsettings, so patch it to also
	# compile under target_os=android and point Cargo at the patched copy
	local _sysproxy_dir="$TERMUX_PKG_TMPDIR/sysproxy-0.3.0-android"
	rm -rf "$_sysproxy_dir"
	mkdir -p "$_sysproxy_dir"
	curl -sL "https://static.crates.io/crates/sysproxy/sysproxy-0.3.0.crate" \
		| tar xz -C "$_sysproxy_dir" --strip-components=1
	(cd "$_sysproxy_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/sysproxy-android.diff"
	echo "sysproxy = { path = \"$_sysproxy_dir\" }" >> Cargo.toml

	# ndk crate's ALooper_pollAll is gone from NDK 33+ (use pollOnce);
	# patch it and override via [patch.crates-io] (tao pulls it in)
	local _ndk_dir="$TERMUX_PKG_TMPDIR/ndk-0.9.0-android"
	rm -rf "$_ndk_dir"
	mkdir -p "$_ndk_dir"
	curl -sL "https://static.crates.io/crates/ndk/ndk-0.9.0.crate" \
		| tar xz -C "$_ndk_dir" --strip-components=1
	(cd "$_ndk_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/ndk-android-pollonce.diff"
	sed -i "/^\[patch.crates-io\]/a ndk = { path = \"$_ndk_dir\" }" Cargo.toml

	# tao (and wry) select their windowing/webview backend purely off
	# target_os: on target_os="android" they pull in the real
	# NativeActivity/ndk_glue backend, which needs a genuine Android
	# Activity+JNI lifecycle to drive it.
	local _tao_dir="$TERMUX_PKG_TMPDIR/tao-0.35.2-android-gtk-x11"
	rm -rf "$_tao_dir"
	mkdir -p "$_tao_dir"
	curl -sL "https://static.crates.io/crates/tao/tao-0.35.2.crate" \
		| tar xz -C "$_tao_dir" --strip-components=1
	(cd "$_tao_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tao-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tao = { path = \"$_tao_dir\" }" Cargo.toml

	# wry (the webview crate) has the SAME target_os-driven split as tao,
	# plus a build.rs step that assumes it's building a real Android app
	# (Kotlin/JNI glue via WRY_ANDROID_* env vars).
	local _wry_dir="$TERMUX_PKG_TMPDIR/wry-0.55.1-android-gtk-x11"
	rm -rf "$_wry_dir"
	mkdir -p "$_wry_dir"
	curl -sL "https://static.crates.io/crates/wry/wry-0.55.1.crate" \
		| tar xz -C "$_wry_dir" --strip-components=1
	(cd "$_wry_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/wry-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a wry = { path = \"$_wry_dir\" }" Cargo.toml

	if [ "$TERMUX_ARCH" = "arm" ]; then
		# cc crate emits legacy --target=arm-linux-androideabi for armv7,
		# which our versioned NDK sysroot rejects; wrap the compiler to
		# rewrite that flag before it reaches the real clang
		local _armcc_wrapdir="$TERMUX_PKG_TMPDIR/armcc-wrapper"
		mkdir -p "$_armcc_wrapdir"
		local _real_arm_clang
		_real_arm_clang="$(command -v arm-linux-androideabi-clang)"
		local _ARMCC="$_armcc_wrapdir/arm-linux-androideabi-clang"
		echo "#!$(readlink /proc/$$/exe)" > "$_ARMCC"
		{
			echo 'args=()'
			echo 'for a in "$@"; do'
			echo '	case "$a" in'
			echo "	--target=arm-linux-androideabi) args+=(\"--target=armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL\") ;;"
			echo '	*) args+=("$a") ;;'
			echo '	esac'
			echo 'done'
			echo "exec \"$_real_arm_clang\" \"\${args[@]}\""
		} >> "$_ARMCC"
		chmod +x "$_ARMCC"
		export PATH="$_armcc_wrapdir:$PATH"
	fi

	# Rust `cmake` crate doesn't cross-compile for Android correctly; wrap
	# cmake to inject the standalone toolchain and force static-lib try_compile
	export CMAKE_POLICY_VERSION_MINIMUM=3.5
	export TARGET_CMAKE_GENERATOR="Ninja"

	# Pin the versioned per-arch target so CMake doesn't compute its own
	local _android_target
	case "$TERMUX_ARCH" in
	aarch64) _android_target="aarch64-linux-android$TERMUX_PKG_API_LEVEL" ;;
	arm) _android_target="armv7a-linux-androideabi$TERMUX_PKG_API_LEVEL" ;;
	i686) _android_target="i686-linux-android$TERMUX_PKG_API_LEVEL" ;;
	x86_64) _android_target="x86_64-linux-android$TERMUX_PKG_API_LEVEL" ;;
	esac

	local _CMAKE="$TERMUX_PKG_TMPDIR/bin/cmake"
	mkdir -p "$(dirname "$_CMAKE")"
	echo "#!$(readlink /proc/$$/exe)" > "$_CMAKE"
	echo "echo CMAKE \"\$@\"" >> "$_CMAKE"
	echo "[[ \"\$@\" =~ \"--build\" ]] && exec $(command -v cmake) \"\$@\" || \
	exec $(command -v cmake) \
	-DCMAKE_ANDROID_STANDALONE_TOOLCHAIN=\"$TERMUX_STANDALONE_TOOLCHAIN\" \
	-DCMAKE_SYSTEM_NAME=Android \
	-DCMAKE_SYSTEM_VERSION=$TERMUX_PKG_API_LEVEL \
	-DCMAKE_LINKER=\"$TERMUX_STANDALONE_TOOLCHAIN/bin/$LD\" \
	-DCMAKE_MAKE_PROGRAM=\"$(command -v ninja)\" \
	-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY \
	-DCMAKE_C_COMPILER_TARGET=\"$_android_target\" \
	-DCMAKE_CXX_COMPILER_TARGET=\"$_android_target\" \
	-DCMAKE_ASM_COMPILER_TARGET=\"$_android_target\" \"\$@\"" >> "$_CMAKE"
	chmod +x "$_CMAKE"

	export PATH="$(dirname "$_CMAKE"):$PATH"
}

termux_step_make() {
	cd "$TERMUX_PKG_SRCDIR"

	npm ci

	# Run bootstrap steps individually instead of `npm run bootstrap`, since
	# vendor-node.cjs/vendor-protoc.cjs fetch glibc binaries; use Termux's
	# own node/protoc instead
	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		node scripts/install-wasm-pack.cjs

		mkdir -p crates-tauri/yaak-app-client/vendored/node
		mkdir -p crates-tauri/yaak-app-client/vendored/protoc/include
		ln -sf "$TERMUX_PREFIX/bin/node" crates-tauri/yaak-app-client/vendored/node/yaaknode
		ln -sf "$TERMUX_PREFIX/bin/protoc" crates-tauri/yaak-app-client/vendored/protoc/yaakprotoc
		cp -r "$TERMUX_PREFIX/include/google" crates-tauri/yaak-app-client/vendored/protoc/include/ 2>/dev/null || true

		# Build every workspace (incl. dist/apps/yaak-client and plugin
		# build/ outputs) before vendor-plugins.cjs copies from them
		npm run build
		node scripts/vendor-plugins.cjs
	)

	# Skip cargo-tauri/npm tauri-cli: only needed for beforeBuildCommand
	# (done above) and glibc-only bundling; build.rs handles compile+embed
	cargo build --release \
		--target "$CARGO_TARGET_NAME" \
		--package yaak-app-client \
		--no-default-features --features wry
}

termux_step_make_install() {
	local target_dir="$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME/release"
	local dest="$TERMUX_PREFIX/opt/yaak"

	rm -rf "$dest"
	mkdir -p "$dest"

	install -Dm755 "$target_dir/yaak-app-client" "$dest/yaak-bin"

	cp -r "$TERMUX_PKG_SRCDIR/crates-tauri/yaak-app-client/static" "$dest/static"
	cp -r "$TERMUX_PKG_SRCDIR/crates-tauri/yaak-app-client/vendored" "$dest/vendored"

	cat > "$TERMUX_PREFIX/bin/yaak" <<-SCRIPT
	#!$TERMUX_PREFIX/bin/sh
	export GDK_BACKEND="\${GDK_BACKEND:-x11}"
	exec "$TERMUX_PREFIX/opt/yaak/yaak-bin" "\$@"
	SCRIPT
	chmod 0755 "$TERMUX_PREFIX/bin/yaak"

	install -Dm644 \
		"$TERMUX_PKG_SRCDIR/crates-tauri/yaak-app-client/icons/release/128x128.png" \
		"$TERMUX_PREFIX/share/icons/hicolor/128x128/apps/yaak.png"

	install -Dm644 /dev/stdin "$TERMUX_PREFIX/share/applications/yaak.desktop" <<-DESKTOP
	[Desktop Entry]
	Name=Yaak
	Comment=Privacy-first desktop API client
	Exec=yaak
	Icon=yaak
	Terminal=false
	Type=Application
	Categories=Development;Network;
	DESKTOP
}
