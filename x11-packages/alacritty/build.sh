TERMUX_PKG_HOMEPAGE=https://alacritty.org/
TERMUX_PKG_DESCRIPTION="A fast, cross-platform, OpenGL terminal emulator"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.15.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b814e30c6271ae23158c66e0e2377c3600bb24041fa382a36e81be564eeb2e36
TERMUX_PKG_DEPENDS="fontconfig, freetype, libxi, libxcursor, libxrandr"
TERMUX_PKG_BUILD_DEPENDS="libxcb, libxkbcommon, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	termux_setup_cmake
	termux_setup_rust
	cargo clean
	cargo vendor

	for dir in ./vendor/rustix*; do
		if [[ -d "$dir/src/backend/libc/shm" && -d "$dir/src/backend/linux_raw/shm" ]]; then
			rm -rf "$dir/src/backend/libc/shm/"*
			cp "$dir/src/backend/linux_raw/shm/"* "$dir/src/backend/libc/shm/"
		fi
	done

	if grep -q '^\[patch\.crates-io\]' Cargo.toml; then
		sed -i '/^\[patch.crates-io\]/,$d' Cargo.toml
	fi

	local patch_lines="" patch_file crate dir
	for patch_file in "$TERMUX_PKG_BUILDER_DIR"/*.vendor.diff; do
		[[ -e "$patch_file" ]] || break
		crate="$(basename "$patch_file" .vendor.diff)"
		dir="./vendor/$crate"
		if [[ ! -d "$dir" ]]; then
			echo "No vendor dir for $crate"
			exit 1
		fi
		sed "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" "$patch_file" | \
			patch --fuzz=0 -p1 -d "$dir"
		patch_lines="${patch_lines}${crate} = { path = \"$dir\" }\n"
	done

	if [[ -n "$patch_lines" ]]; then
		printf "\n[patch.crates-io]\n$patch_lines" >> Cargo.toml
	fi
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

	scdoc < extra/man/alacritty.1.scd | gzip -c \
		> "$TERMUX_PREFIX/share/man/man1/alacritty.1.gz"
	scdoc < extra/man/alacritty-msg.1.scd | gzip -c \
		> "$TERMUX_PREFIX/share/man/man1/alacritty-msg.1.gz"
	scdoc < extra/man/alacritty.5.scd | gzip -c \
		> "$TERMUX_PREFIX/share/man/man5/alacritty.5.gz"
	scdoc < extra/man/alacritty-bindings.5.scd | gzip -c \
		> "$TERMUX_PREFIX/share/man/man5/alacritty-bindings.5.gz"

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
