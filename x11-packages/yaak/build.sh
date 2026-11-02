TERMUX_PKG_HOMEPAGE=https://yaak.app/
TERMUX_PKG_DESCRIPTION="Fast, privacy-first desktop API client for REST, GraphQL, SSE, WebSocket and gRPC"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2026.8.1"
TERMUX_PKG_SRCURL="https://github.com/mountain-loop/yaak/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=58c5b659e5eb565fa069009740dd7493ff9204ef8f62223c75afb07a7a5de3fe
TERMUX_PKG_AUTO_UPDATE=true

# Plugins run via Node.js at runtime
TERMUX_PKG_DEPENDS="fontconfig, gtk3, libx11, nodejs|nodejs-lts, openssl, webkit2gtk-4.1"

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

	# route tao's target_os=android to its linux(GTK/X11) backend
	local _tao_dir="$TERMUX_PKG_TMPDIR/tao-0.35.2-android-gtk-x11"
	rm -rf "$_tao_dir"
	mkdir -p "$_tao_dir"
	curl -sL "https://static.crates.io/crates/tao/tao-0.35.2.crate" \
		| tar xz -C "$_tao_dir" --strip-components=1
	(cd "$_tao_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tao-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tao = { path = \"$_tao_dir\" }" Cargo.toml

	# same fix for wry (webview backend); version guessed to match tao 0.35.2, verify against yaak's Cargo.lock
	local _wry_dir="$TERMUX_PKG_TMPDIR/wry-0.55.1-android-gtk-x11"
	rm -rf "$_wry_dir"
	mkdir -p "$_wry_dir"
	curl -sL "https://static.crates.io/crates/wry/wry-0.55.1.crate" \
		| tar xz -C "$_wry_dir" --strip-components=1
	(cd "$_wry_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/wry-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a wry = { path = \"$_wry_dir\" }" Cargo.toml

	# same fix for tauri/tauri-runtime(-wry)/tauri-utils git deps; rev must match yaak's Cargo.lock
	local _tauri_src_dir="$TERMUX_PKG_TMPDIR/tauri-src-d9bc695c-android-gtk-x11"
	rm -rf "$_tauri_src_dir"
	mkdir -p "$_tauri_src_dir"
	curl -sL "https://codeload.github.com/tauri-apps/tauri/tar.gz/d9bc695c18d9a25baec21d8a5f36d72e3a14ee53" \
		| tar xz -C "$_tauri_src_dir" --strip-components=1
	(cd "$_tauri_src_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-runtime-and-wry-android-gtk-x11.diff"

	# The runtime already behaves as desktop linux (custom_scheme_url is patched
	# to ipc://localhost), but the scripts injected into the webview take their
	# os_name from std::env::consts::OS, i.e. "android". That makes the JS build
	# http://ipc.localhost URLs, which nothing serves: IPC channel fetches fail
	# and the frontend hangs on a blank page. Report "linux" to the webview.
	sed -i 's/std::env::consts::OS,/if cfg!(target_os = "android") { "linux" } else { std::env::consts::OS },/' \
		"$_tauri_src_dir/crates/tauri/src/app.rs" \
		"$_tauri_src_dir/crates/tauri/src/manager/webview.rs" \
		"$_tauri_src_dir/crates/tauri/src/window/plugin.rs"
	if [ "$(grep -c 'cfg!(target_os = "android") { "linux" }' \
		"$_tauri_src_dir/crates/tauri/src/app.rs" \
		"$_tauri_src_dir/crates/tauri/src/manager/webview.rs" \
		"$_tauri_src_dir/crates/tauri/src/window/plugin.rs" | awk -F: '{s+=$2} END {print s}')" != "4" ]; then
		termux_error_exit "tauri os_name patch did not apply to all 4 places"
	fi

	# yaak already patches tauri/tauri-build via [patch.crates-io]; rewrite
	# those entries in place instead of adding a second [patch] table, which
	# cargo silently ignores ("patch was not used in the crate graph")
	sed -i \
		-e "s#tauri = { git = \"https://github.com/tauri-apps/tauri\", rev = \"d9bc695c18d9a25baec21d8a5f36d72e3a14ee53\" }#tauri = { path = \"$_tauri_src_dir/crates/tauri\" }#" \
		-e "s#tauri-build = { git = \"https://github.com/tauri-apps/tauri\", rev = \"d9bc695c18d9a25baec21d8a5f36d72e3a14ee53\" }#tauri-build = { path = \"$_tauri_src_dir/crates/tauri-build\" }#" \
		Cargo.toml

	# tauri-plugin build-dep sets its own mobile/desktop cfg from target_os=android
	local _tauri_plugin_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-2.6.3-android-gtk-x11"
	rm -rf "$_tauri_plugin_dir"
	mkdir -p "$_tauri_plugin_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin/tauri-plugin-2.6.3.crate" \
		| tar xz -C "$_tauri_plugin_dir" --strip-components=1
	(cd "$_tauri_plugin_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin = { path = \"$_tauri_plugin_dir\" }" Cargo.toml

	# tauri-plugin-deep-link also gates on raw target_os=android directly; route it too
	local _tauri_plugin_deep_link_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-deep-link-2.4.10-android-gtk-x11"
	rm -rf "$_tauri_plugin_deep_link_dir"
	mkdir -p "$_tauri_plugin_deep_link_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-deep-link/tauri-plugin-deep-link-2.4.10.crate" \
		| tar xz -C "$_tauri_plugin_deep_link_dir" --strip-components=1
	(cd "$_tauri_plugin_deep_link_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-deep-link-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-deep-link = { path = \"$_tauri_plugin_deep_link_dir\" }" Cargo.toml

	# tauri-plugin-fs also gates on raw target_os=android directly; route it too
	local _tauri_plugin_fs_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-fs-2.5.2-android-gtk-x11"
	rm -rf "$_tauri_plugin_fs_dir"
	mkdir -p "$_tauri_plugin_fs_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-fs/tauri-plugin-fs-2.5.2.crate" \
		| tar xz -C "$_tauri_plugin_fs_dir" --strip-components=1
	(cd "$_tauri_plugin_fs_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-fs-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-fs = { path = \"$_tauri_plugin_fs_dir\" }" Cargo.toml

	# tauri-plugin-shell has its own mobile cfg and raw android gates
	local _tauri_plugin_shell_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-shell-2.3.6-android-gtk-x11"
	rm -rf "$_tauri_plugin_shell_dir"
	mkdir -p "$_tauri_plugin_shell_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-shell/tauri-plugin-shell-2.3.6.crate" \
		| tar xz -C "$_tauri_plugin_shell_dir" --strip-components=1
	(cd "$_tauri_plugin_shell_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-shell-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-shell = { path = \"$_tauri_plugin_shell_dir\" }" Cargo.toml

	# tauri-plugin-opener has its own mobile cfg and raw android gates
	local _tauri_plugin_opener_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-opener-2.5.5-android-gtk-x11"
	rm -rf "$_tauri_plugin_opener_dir"
	mkdir -p "$_tauri_plugin_opener_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-opener/tauri-plugin-opener-2.5.5.crate" \
		| tar xz -C "$_tauri_plugin_opener_dir" --strip-components=1
	(cd "$_tauri_plugin_opener_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-opener-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-opener = { path = \"$_tauri_plugin_opener_dir\" }" Cargo.toml

	# rfd (file dialogs) has no android backend; use its gtk3 one
	local _rfd_dir="$TERMUX_PKG_TMPDIR/rfd-0.16.0-android-gtk-x11"
	rm -rf "$_rfd_dir"
	mkdir -p "$_rfd_dir"
	curl -sL "https://static.crates.io/crates/rfd/rfd-0.16.0.crate" \
		| tar xz -C "$_rfd_dir" --strip-components=1
	(cd "$_rfd_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/rfd-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a rfd = { path = \"$_rfd_dir\" }" Cargo.toml

	# tauri-plugin-dialog: rfd/raw-window-handle deps are desktop-OS only
	local _tauri_plugin_dialog_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-dialog-2.7.2-android-gtk-x11"
	rm -rf "$_tauri_plugin_dialog_dir"
	mkdir -p "$_tauri_plugin_dialog_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-dialog/tauri-plugin-dialog-2.7.2.crate" \
		| tar xz -C "$_tauri_plugin_dialog_dir" --strip-components=1
	(cd "$_tauri_plugin_dialog_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-dialog-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-dialog = { path = \"$_tauri_plugin_dialog_dir\" }" Cargo.toml

	# arboard excludes android; enable its x11/wayland backend
	local _arboard_dir="$TERMUX_PKG_TMPDIR/arboard-3.6.1-android-gtk-x11"
	rm -rf "$_arboard_dir"
	mkdir -p "$_arboard_dir"
	curl -sL "https://static.crates.io/crates/arboard/arboard-3.6.1.crate" \
		| tar xz -C "$_arboard_dir" --strip-components=1
	(cd "$_arboard_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/arboard-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a arboard = { path = \"$_arboard_dir\" }" Cargo.toml

	# tauri-plugin-clipboard-manager: arboard dep is desktop-OS only
	local _tauri_plugin_clipboard_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-clipboard-manager-2.3.3-android-gtk-x11"
	rm -rf "$_tauri_plugin_clipboard_dir"
	mkdir -p "$_tauri_plugin_clipboard_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-clipboard-manager/tauri-plugin-clipboard-manager-2.3.3.crate" \
		| tar xz -C "$_tauri_plugin_clipboard_dir" --strip-components=1
	(cd "$_tauri_plugin_clipboard_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-clipboard-manager-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-clipboard-manager = { path = \"$_tauri_plugin_clipboard_dir\" }" Cargo.toml

	# tauri-plugin-updater: no install_inner for android; make it a no-op
	local _tauri_plugin_updater_dir="$TERMUX_PKG_TMPDIR/tauri-plugin-updater-2.11.0-android-gtk-x11"
	rm -rf "$_tauri_plugin_updater_dir"
	mkdir -p "$_tauri_plugin_updater_dir"
	curl -sL "https://static.crates.io/crates/tauri-plugin-updater/tauri-plugin-updater-2.11.0.crate" \
		| tar xz -C "$_tauri_plugin_updater_dir" --strip-components=1
	(cd "$_tauri_plugin_updater_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/tauri-plugin-updater-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a tauri-plugin-updater = { path = \"$_tauri_plugin_updater_dir\" }" Cargo.toml

	# muda (tray/app menus) only builds its gtk backend for target_os=linux
	# and friends; route android to it too
	local _muda_dir="$TERMUX_PKG_TMPDIR/muda-0.19.1-android-gtk-x11"
	rm -rf "$_muda_dir"
	mkdir -p "$_muda_dir"
	curl -sL "https://static.crates.io/crates/muda/muda-0.19.1.crate" \
		| tar xz -C "$_muda_dir" --strip-components=1
	(cd "$_muda_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/muda-android-gtk-x11.diff"
	sed -i "/^\[patch.crates-io\]/a muda = { path = \"$_muda_dir\" }" Cargo.toml

	# servo-fontconfig-sys skips pkg-config on android and statically links a
	# bundled fontconfig 2.11, which can't parse Termux's current fontconfig
	# config files; make it link the system libfontconfig instead
	local _sfs_dir="$TERMUX_PKG_TMPDIR/servo-fontconfig-sys-5.1.0-system-lib"
	rm -rf "$_sfs_dir"
	mkdir -p "$_sfs_dir"
	curl -sL "https://static.crates.io/crates/servo-fontconfig-sys/servo-fontconfig-sys-5.1.0.crate" \
		| tar xz -C "$_sfs_dir" --strip-components=1
	(cd "$_sfs_dir" && patch -p1) < "$TERMUX_PKG_BUILDER_DIR/servo-fontconfig-sys-system-lib.diff"
	sed -i "/^\[patch.crates-io\]/a servo-fontconfig-sys = { path = \"$_sfs_dir\" }" Cargo.toml
	export PKG_CONFIG_ALLOW_CROSS=1

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

		# DIAGNOSTIC (Termux): surface any error/hang during the very first
		# React mount directly on the white page. Safe to drop once the
		# blank-page issue is understood.
		python3 "$TERMUX_PKG_BUILDER_DIR/inject-diag-overlay.py"

		# FIX ATTEMPT (Termux), tried and reverted: disabling autoCodeSplitting
		# to rule out route-level lazy-import Suspense as the cause of the
		# blank page made things WORSE (no window at all, vs. a blank but
		# inspectable one), so it's reverted. Left here as a note so it isn't
		# retried blindly.
		# sed -i 's/autoCodeSplitting: true,/autoCodeSplitting: false,/' \
		# 	apps/yaak-client/vite.config.ts

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
	# tauri/custom-protocol is what `tauri build` passes for release builds;
	# without it tauri::is_dev() is true, so the app loads the frontend from
	# devUrl (localhost:1420) and looks for plugins in ../../plugins
	cargo build --release \
		--target "$CARGO_TARGET_NAME" \
		--package yaak-app-client \
		--no-default-features --features wry,tauri/custom-protocol
}

termux_step_make_install() {
	local target_dir="$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME/release"
	local dest="$TERMUX_PREFIX/opt/yaak"

	# tauri-utils is patched (see tauri-runtime-and-wry-android-gtk-x11.diff)
	# so that on android resource_dir() is the directory of the executable:
	# static/ and vendored/ must sit right next to yaak-bin
	rm -rf "$dest"
	mkdir -p "$dest"

	install -Dm755 "$target_dir/yaak-app-client" "$dest/yaak-bin"

	cp -r "$TERMUX_PKG_SRCDIR/crates-tauri/yaak-app-client/static" "$dest/static"
	cp -r "$TERMUX_PKG_SRCDIR/crates-tauri/yaak-app-client/vendored" "$dest/vendored"

	cat > "$TERMUX_PREFIX/bin/yaak" <<-SCRIPT
	#!$TERMUX_PREFIX/bin/sh
	# The app probes for a separate Yaak CLI by running \`yaak --version\` and
	# waits for it to exit. This launcher would start yet another GUI instance
	# that probes again, forever (upstream is saved by single-instance over
	# D-Bus, which is usually not available on Termux). Report "no CLI".
	if [ -n "\${YAAK_TERMUX_LAUNCHER:-}" ]; then
		exit 127
	fi
	export YAAK_TERMUX_LAUNCHER=1
	export GDK_BACKEND="\${GDK_BACKEND:-x11}"
	# Termux:X11 usually has no DRI3, so WebKit's GPU compositor fails
	export WEBKIT_DISABLE_COMPOSITING_MODE="\${WEBKIT_DISABLE_COMPOSITING_MODE:-1}"
	export WEBKIT_DISABLE_DMABUF_RENDERER="\${WEBKIT_DISABLE_DMABUF_RENDERER:-1}"
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
