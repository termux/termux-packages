TERMUX_PKG_HOMEPAGE=https://alacritty.org/
TERMUX_PKG_DESCRIPTION="A fast, cross-platform, OpenGL terminal emulator"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.16.1"
TERMUX_PKG_SRCURL="https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=b7240df4a52c004470977237a276185fc97395d59319480d67cad3c4347f395e
TERMUX_PKG_DEPENDS="fontconfig, freetype, libxcursor, libxi, libxrandr"
TERMUX_PKG_BUILD_DEPENDS="libxcb, libxkbcommon, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	termux_setup_cmake
	termux_setup_rust
	cargo clean
	cargo vendor

	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/copypasta \
		! -wholename ./vendor/freetype-sys \
		! -wholename ./vendor/glutin \
		! -wholename ./vendor/glutin_glx_sys \
		! -wholename ./vendor/smithay-client-toolkit \
		! -wholename ./vendor/wayland-cursor \
		! -wholename ./vendor/winit \
		! -wholename ./vendor/x11rb-protocol \
		! -wholename ./vendor/xkbcommon-dl \
		-exec rm -rf '{}' \;

	local diff crate_name
	for diff in "$TERMUX_PKG_BUILDER_DIR"/*.vendor.diff; do
		crate_name="$(basename "$diff" .vendor.diff)"
		echo "Applying patch: $diff"
		patch -p1 < "$diff"
	done

	local -a CARGO_PATCH_LINES=()
	for crate_name in copypasta freetype-sys glutin glutin_glx_sys smithay-client-toolkit wayland-cursor winit x11rb-protocol xkbcommon-dl; do
		find "vendor/$crate_name" -type f -print0 | \
			xargs -0 sed -i \
			-e 's|"android"|"disabling_this_because_it_is_for_building_an_apk"|g' \
			-e 's|"linux"|"android"|g' \
			-e "s|libxkbcommon.so.0|libxkbcommon.so|g" \
			-e "s|libxkbcommon-x11.so.0|libxkbcommon-x11.so|g" \
			-e "s|libxcb.so.1|libxcb.so|g" \
			-e "s|/tmp|$TERMUX_PREFIX/tmp|g"
		CARGO_PATCH_LINES+=("$crate_name = { path = \"./vendor/$crate_name\" }")
	done

	{
		printf '%s\n' \
			"" \
			"[patch.crates-io]" \
			"${CARGO_PATCH_LINES[@]}"
	} >> Cargo.toml
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" \
		"target/$CARGO_TARGET_NAME/release/alacritty"

	scdoc < extra/man/alacritty.1.scd | gzip -c > "$TERMUX_PREFIX/share/man/man1/alacritty.1.gz"
	scdoc < extra/man/alacritty-msg.1.scd | gzip -c > "$TERMUX_PREFIX/share/man/man1/alacritty-msg.1.gz"
	scdoc < extra/man/alacritty.5.scd | gzip -c > "$TERMUX_PREFIX/share/man/man5/alacritty.5.gz"
	scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > "$TERMUX_PREFIX/share/man/man5/alacritty-bindings.5.gz"

	install -Dm644 extra/completions/_alacritty \
		"$TERMUX_PREFIX/share/zsh/site-functions/_alacritty"
	install -Dm644 extra/completions/alacritty.bash \
		"$TERMUX_PREFIX/share/bash-completion/completions/alacritty.bash"
	install -Dm644 extra/completions/alacritty.fish \
		"$TERMUX_PREFIX/share/fish/vendor_completions.d/alacritty.fish"
	install -Dm644 extra/linux/Alacritty.desktop \
		"$TERMUX_PREFIX/share/applications/Alacritty.desktop"
	install -Dm644 extra/logo/alacritty-term.svg \
		"$TERMUX_PREFIX/share/icons/hicolor/scalable/apps/Alacritty.svg"
}
