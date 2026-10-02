TERMUX_PKG_HOMEPAGE=https://zed.dev
TERMUX_PKG_DESCRIPTION="High-performance, multiplayer code editor"
TERMUX_PKG_LICENSE="GPL-3.0, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-GPL, LICENSE-APACHE"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.21.0"
TERMUX_PKG_SRCURL="https://github.com/zed-industries/zed/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=37356f2cb6ca4714937be200edad278cb0f6137b4c3eec66a0743b5f523e1ee5
TERMUX_PKG_DEPENDS="alsa-lib, fontconfig, freetype, libwayland, libx11, libxcb, libxkbcommon, openssl, vulkan-loader-generic, zlib"
TERMUX_PKG_BUILD_DEPENDS="libwayland-protocols, vulkan-headers"
TERMUX_PKG_RECOMMENDS="git, vulkan-icd"
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cmake

	# Clash with the host build
	unset CFLAGS CXXFLAGS

	# Replicates .cargo/config.toml.
	# Append to the target RUSTFLAGS set up by termux_setup_rust instead of
	# overriding them, that would drop the -L/-rpath flags for $PREFIX/lib.
	local -u env_host="${CARGO_TARGET_NAME//-/_}"
	local target_rustflags="CARGO_TARGET_${env_host}_RUSTFLAGS"
	# NOTE: ${!target_rustflags} is variable indirection, it expands to the value of
	# the variable *named* by $target_rustflags. It is not the ${!array[@]} keys expansion.
	export "${target_rustflags}=${!target_rustflags:-} --cfg tokio_unstable -C symbol-mangling-version=v0"

	# Fat LTO + 1 codegen unit needs too much RAM
	export CARGO_PROFILE_RELEASE_LTO=off
	export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
	export CARGO_PROFILE_RELEASE_DEBUG=0

	# Disable the built-in updater
	export ZED_UPDATE_EXPLANATION="Zed was installed via Termux. Run 'pkg upgrade zed' to update."

	# Zed has no Android target, enable the Linux (Wayland/X11) code paths on Android.
	# livekit_client keeps its Linux cfgs, since libwebrtc has no Android build.
	# Doing this as a static patch results in a 2800+ line file and would be infeasible to keep up to date.
	find crates \( -name '*.rs' -o -name Cargo.toml \) \
		! -path crates/livekit_client/Cargo.toml \
		! -path crates/livekit_client/src/livekit_client.rs \
		-exec sed -i \
		's|target_os = "linux"|any(target_os = "linux", target_os = "android")|g' '{}' +
	# Reuse the FreeBSD stubs where Linux needs a prebuilt libwebrtc (livekit_client)
	find crates/audio crates/call crates/livekit_client \( -name '*.rs' -o -name Cargo.toml \) \
		-exec sed -i \
		's|target_os = "freebsd"|any(target_os = "freebsd", target_os = "android")|g' '{}' +

	cargo vendor

	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/alacritty_terminal \
		! -wholename ./vendor/cpal \
		! -wholename ./vendor/ipc-channel \
		! -wholename ./vendor/rustls-platform-verifier \
		! -wholename ./vendor/trash \
		! -wholename ./vendor/wasmtime-internal-jit-icache-coherence \
		! -wholename ./vendor/wayland-cursor \
		! -wholename ./vendor/x11rb-protocol \
		! -wholename ./vendor/zed-scap \
		-exec rm -rf '{}' \;

	# rustls-platform-verifier: use the generic Linux backend (rustls-native-certs)
	# instead of the Android JNI one, which needs a JVM.
	find vendor/rustls-platform-verifier -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		-e "s|ANDROID|DISABLING_THIS_BECAUSE_IT_IS_FOR_BUILDING_AN_APK|g" \
		-e 's|"linux"|"android"|g'

	# cpal: its Android backend links -laaudio, which only exists for API >= 26, so the
	# program would not run on older devices. Disable that backend, cpal then falls
	# back to its null host.
	[[ -d vendor/cpal ]] || termux_error_exit "vendor/cpal not found, was cpal vendored under another name?"
	find vendor/cpal -type f -print0 | \
		xargs -0 sed -i \
		-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g'

	# trash: the manifest is rewritten by `cargo vendor`, so a diff for it would be fragile.
	# The same cfg replacement as in trash.vendor.diff, applied to Cargo.toml only.
	sed -i \
		's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
		vendor/trash/Cargo.toml

	# zed-scap: enable the Linux/FreeBSD dependencies (xcb, x11, ...) on Android.
	# Same as for trash, the manifest is handled here since its layout is rewritten by
	# `cargo vendor`. Matches both the plain and the escaped (\") quote form of the cfg.
	sed -i \
		's|\(target_os = \\\?"\)freebsd|\1android|g' \
		vendor/zed-scap/Cargo.toml
	grep -q 'target_os = \\\?"android' vendor/zed-scap/Cargo.toml ||
		termux_error_exit "Failed to patch the cfg in vendor/zed-scap/Cargo.toml"

	# Patch the vendored crates and point the workspace to them
	local diff
	for diff in "${TERMUX_PKG_BUILDER_DIR}"/*.vendor.diff; do
		echo "Applying patch: ${diff}"
		sed "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" "${diff}" | patch --silent -p1
	done

	cargo fetch --target "${CARGO_TARGET_NAME}"
}

termux_step_make() {
	cargo build \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release \
		--package zed \
		--package cli
}

termux_step_make_install() {
	local target_dir="target/${CARGO_TARGET_NAME}/release"

	install -Dm755 "${target_dir}/cli" "${TERMUX_PREFIX}/bin/zed"
	install -Dm755 "${target_dir}/zed" "${TERMUX_PREFIX}/libexec/zed/zed-editor"

	# The CLI looks for ../libexec/zed-editor, see zed-shim.sh for details.
	sed "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
		"${TERMUX_PKG_BUILDER_DIR}/zed-shim.sh" \
		> "${TERMUX_PREFIX}/libexec/zed-editor"
	chmod 755 "${TERMUX_PREFIX}/libexec/zed-editor"

	install -Dm644 crates/zed/resources/app-icon.png \
		"${TERMUX_PREFIX}/share/icons/hicolor/512x512/apps/zed.png"
	install -Dm644 crates/zed/resources/app-icon@2x.png \
		"${TERMUX_PREFIX}/share/icons/hicolor/1024x1024/apps/zed.png"

	# The file name must match the app id (dev.zed.Zed), which Zed sets as the
	# Wayland app_id / X11 WM_CLASS, or the window won't be matched to its icon
	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" \
		"${TERMUX_PKG_BUILDER_DIR}/dev.zed.Zed.desktop"

	# Shell completions, generated by a host build of the CLI.
	# The completions are named after the executable, so it has to be called zed.
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	(
		unset CC CXX CFLAGS CXXFLAGS CPPFLAGS LDFLAGS AR AS CPP LD RANLIB READELF STRIP
		cargo build --jobs "${TERMUX_PKG_MAKE_PROCESSES}" --release --package cli

		local host_zed="${TERMUX_PKG_TMPDIR}/host-bin/zed"
		install -Dm755 target/release/cli "${host_zed}"

		# --zed skips the lookup of the editor binary, which doesn't exist next to the host CLI
		"${host_zed}" --zed "${host_zed}" --completions zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_zed"
		"${host_zed}" --zed "${host_zed}" --completions bash > "${TERMUX_PREFIX}/share/bash-completion/completions/zed"
		"${host_zed}" --zed "${host_zed}" --completions fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/zed.fish"
		"${host_zed}" --zed "${host_zed}" --completions elvish > "${TERMUX_PREFIX}/share/elvish/lib/zed.elv"
	)
}
