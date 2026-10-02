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
TERMUX_PKG_UPDATE_TAG_TYPE="latest-release-tag"

termux_step_post_get_source() {
	# Enable gpui's Wayland/X11 backend on Android (livekit_client handled below)
	grep -rlE 'target_os = "linux"' crates --include=*.rs --include=Cargo.toml |
		grep -v '^crates/livekit_client/' |
		xargs sed -i 's/target_os = "linux"/any(target_os = "linux", target_os = "android")/g'

	# No libwebrtc prebuilt for Android: reuse the FreeBSD no-op stub
	sed -i \
		-e 's/target_os = "freebsd"/any(target_os = "freebsd", target_os = "android")/g' \
		crates/livekit_client/Cargo.toml \
		crates/livekit_client/src/lib.rs \
		crates/audio/Cargo.toml \
		crates/audio/src/audio_pipeline/echo_canceller.rs \
		crates/call/src/call_impl/diagnostics.rs

	# call::Room needs publish_screenshare_track_wayland from the mock client
	sed -i \
		's/target_os = "linux"/any(target_os = "linux", target_os = "android")/g' \
		crates/livekit_client/src/mock_client/participant.rs
}

# Run sed on *.rs and Cargo.toml of a vendored crate
__zed_sed_vendored() {
	local _dir="$1"
	shift
	[[ -d "${_dir}" ]] || termux_error_exit "Vendored crate not found: ${_dir}"
	find "${_dir}" -type f \( -name '*.rs' -o -name 'Cargo.toml' \) -print0 |
		xargs -0 sed -i "$@"
}

# Apply a builder-dir diff to a vendored crate
__zed_patch_vendored() {
	local _dir="$1" _diff="$2"
	[[ -d "${_dir}" ]] || termux_error_exit "Vendored crate not found: ${_dir}"
	sed "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" "${TERMUX_PKG_BUILDER_DIR}/${_diff}" |
		patch --silent -p1 -d "${_dir}"
}

termux_step_pre_configure() {
	termux_setup_rust

	# Some crates call host cmake
	termux_setup_cmake

	# Clash with the host build
	unset CFLAGS CXXFLAGS

	# Replicates .cargo/config.toml; append to the target RUSTFLAGS, as plain RUSTFLAGS
	# would drop the -L/-rpath flags for $PREFIX/lib
	local _env_host="${CARGO_TARGET_NAME//-/_}"
	local _target_rustflags="CARGO_TARGET_${_env_host@U}_RUSTFLAGS"
	export "${_target_rustflags}=${!_target_rustflags:-} --cfg tokio_unstable -C symbol-mangling-version=v0"

	# cpal links -laaudio, which the NDK only ships for api >= 26
	if (( TERMUX_PKG_API_LEVEL < 26 )); then
		local _aaudio_dir="${TERMUX_PKG_TMPDIR}/libaaudio"
		rm -rf "${_aaudio_dir}"
		mkdir -p "${_aaudio_dir}"
		cp "${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr/lib/${TERMUX_HOST_PLATFORM}/26/libaaudio.so" \
			"${_aaudio_dir}"
		export "${_target_rustflags}=${!_target_rustflags} -L native=${_aaudio_dir}"
	fi

	# Fat LTO + 1 codegen unit needs too much RAM
	export CARGO_PROFILE_RELEASE_LTO=off
	export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=16
	export CARGO_PROFILE_RELEASE_DEBUG=0

	# Disable the built-in updater
	export ZED_UPDATE_EXPLANATION="Zed was installed via Termux. Run 'pkg upgrade zed' to update."

	# Vendor deps and keep only the crates that need patches
	local _vendor_dir="vendor-termux"
	cargo vendor "${_vendor_dir}" >/dev/null
	local _keep=(
		alacritty_terminal
		ipc-channel
		trash
		wayland-cursor
		x11rb-protocol
		zed-scap
	)
	local _find_args=(-mindepth 1 -maxdepth 1 -type d)
	local _k
	for _k in "${_keep[@]}"; do
		_find_args+=(! -name "${_k}")
	done
	find "${_vendor_dir}" "${_find_args[@]}" -exec rm -rf '{}' +

	# x11rb: use $PREFIX/tmp/.X11-unix instead of /tmp/.X11-unix
	__zed_patch_vendored "${_vendor_dir}/x11rb-protocol" x11rb-protocol-termux-path.diff

	# ipc-channel: use the unix-socket backend on Android (fixes zed CLI handshake)
	__zed_patch_vendored "${_vendor_dir}/ipc-channel" ipc-channel-android-unix.diff

	# zed-scap: treat Android as FreeBSD
	__zed_sed_vendored "${_vendor_dir}/zed-scap" \
		's/target_os = "freebsd"/any(target_os = "freebsd", target_os = "android")/g'

	# trash: enable the freedesktop backend on Android, parse /proc/mounts (no getmntent)
	__zed_patch_vendored "${_vendor_dir}/trash" trash-android-mount-points.diff
	__zed_sed_vendored "${_vendor_dir}/trash" 's/, not(target_os = "android")//g'

	# alacritty_terminal: apply Linux-only IUTF8/PTY handling to Android
	__zed_sed_vendored "${_vendor_dir}/alacritty_terminal" \
		's/target_os = "linux"/any(target_os = "linux", target_os = "android")/g'

	# wayland-cursor: use memfd only, rustix::shm is unavailable on Android
	__zed_patch_vendored "${_vendor_dir}/wayland-cursor" wayland-cursor-android-no-shm.diff

	# Override the crates in Cargo.toml
	sed -i \
		-e "/^\\[patch.crates-io\\]/a x11rb-protocol = { path = \"${_vendor_dir}/x11rb-protocol\" }" \
		-e "/^\\[patch.crates-io\\]/a ipc-channel = { path = \"${_vendor_dir}/ipc-channel\" }" \
		-e "/^\\[patch.crates-io\\]/a wayland-cursor = { path = \"${_vendor_dir}/wayland-cursor\" }" \
		Cargo.toml
	cat >>Cargo.toml <<-EOF

		[patch."https://github.com/zed-industries/scap"]
		zed-scap = { path = "${_vendor_dir}/zed-scap" }

		[patch."https://github.com/zed-industries/trash-rs"]
		trash = { path = "${_vendor_dir}/trash" }

		[patch."https://github.com/zed-industries/alacritty"]
		alacritty_terminal = { path = "${_vendor_dir}/alacritty_terminal" }
	EOF

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
	local _target_dir="target/${CARGO_TARGET_NAME}/release"

	install -Dm755 "${_target_dir}/cli" "${TERMUX_PREFIX}/bin/zed"
	install -Dm755 "${_target_dir}/zed" "${TERMUX_PREFIX}/libexec/zed/zed-editor"

	# The CLI looks for ../libexec/zed-editor; wrap it to allow emulated (software) GPUs
	install -Dm755 /dev/stdin "${TERMUX_PREFIX}/libexec/zed-editor" <<-WRAPPER
	#!${TERMUX_PREFIX}/bin/sh
	export ZED_ALLOW_EMULATED_GPU="\${ZED_ALLOW_EMULATED_GPU:-1}"
	exec "${TERMUX_PREFIX}/libexec/zed/zed-editor" "\$@"
	WRAPPER

	install -Dm644 crates/zed/resources/app-icon.png \
		"${TERMUX_PREFIX}/share/icons/hicolor/512x512/apps/zed.png"
	install -Dm644 crates/zed/resources/app-icon@2x.png \
		"${TERMUX_PREFIX}/share/icons/hicolor/1024x1024/apps/zed.png"

	# The file name must match the app id (dev.zed.Zed), which Zed sets as the
	# Wayland app_id / X11 WM_CLASS, or the window won't be matched to its icon
	install -Dm644 -t "${TERMUX_PREFIX}/share/applications" \
		"${TERMUX_PKG_BUILDER_DIR}/dev.zed.Zed.desktop"
}
