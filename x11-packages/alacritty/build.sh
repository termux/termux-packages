TERMUX_PKG_HOMEPAGE=https://alacritty.org/
TERMUX_PKG_DESCRIPTION="A fast, cross-platform, OpenGL terminal emulator"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
# Keep in sync with packages/ncurses/build.sh
TERMUX_PKG_VERSION=0.13.2
TERMUX_PKG_SRCURL=https://github.com/alacritty/alacritty/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9a54aabc92bbdc25ab1659c2e5a1e9b76f27d101342c8219cc98a730fd46d90
TERMUX_PKG_DEPENDS="fontconfig, freetype, libxi, libxcursor, libxrandr"
TERMUX_PKG_BUILD_DEPENDS="libxcb, libxkbcommon, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

__cargo_fetch_dep_source_for_rust_windowing() {
	local _name="$1"
	local _version
	_version=$(cargo metadata --format-version=1 --no-deps | jq -r ".packages[0].dependencies[] | select(.name==\"$_name\") | .req")
	_version="${_version/^/}"
	local _url="https://github.com/rust-windowing/$_name/archive/refs/tags/v$_version.tar.gz"
	local _path="$TERMUX_PKG_CACHEDIR/$_name-v$_version.tar.gz"
	termux_download "$_url" "$_path" SKIP_CHECKSUM
	tar xf "$_path" -C "$TERMUX_PKG_SRCDIR"
	mv "$_name-$_version" "$_name-source"
}

termux_step_pre_configure() {
	termux_setup_cmake
	termux_setup_rust

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	__cargo_fetch_dep_source_for_rust_windowing "winit"
	__cargo_fetch_dep_source_for_rust_windowing "glutin"

	patch="$TERMUX_PKG_BUILDER_DIR/patch-root-Cargo.diff"
	patch --silent -p1 -d "$TERMUX_PKG_SRCDIR" < "$patch"

	cat "$TERMUX_PKG_BUILDER_DIR"/winit-*.diff | patch -p1 -d "$TERMUX_PKG_SRCDIR/winit-source"
	cat "$TERMUX_PKG_BUILDER_DIR"/glutin-*.diff | patch -p1 -d "$TERMUX_PKG_SRCDIR/glutin-source"

	cargo update

	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/expat-sys-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/freetype-sys-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/rustix-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/servo-fontconfig-sys-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/x11rb-protocol-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local crate
	for crate in {{expat,freetype,servo-fontconfig}-sys,rustix,x11rb-protocol}; do
		local patch="$TERMUX_PKG_BUILDER_DIR/${crate}.diff"
		local dir
		for dir in "$CARGO_HOME"/registry/src/index.crates.io-*/"${crate}"-*; do
			local _crate_name
			_crate_name=$(basename "$dir")
			# shellcheck disable=SC2295
			if [[ ! "${_crate_name#$crate-}" =~ ^[0-9] ]]; then
				continue
			fi
			if [[ "$crate" == 'rustix' ]]; then
				rm -rf "$dir"/src/backend/libc/shm/*
				cp "$dir"/src/backend/linux_raw/shm/* "$dir"/src/backend/libc/shm/
			fi
			patch --silent -p1 -d "$dir" < "${patch}"
		done
	done
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/$CARGO_TARGET_NAME/release/alacritty"

	# man pages
	scdoc < extra/man/alacritty.1.scd          | gzip -c > "$TERMUX_PREFIX/share/man/man1/alacritty.1.gz"
	scdoc < extra/man/alacritty-msg.1.scd      | gzip -c > "$TERMUX_PREFIX/share/man/man1/alacritty-msg.1.gz"
	scdoc < extra/man/alacritty.5.scd          | gzip -c > "$TERMUX_PREFIX/share/man/man5/alacritty.5.gz"
	scdoc < extra/man/alacritty-bindings.5.scd | gzip -c > "$TERMUX_PREFIX/share/man/man5/alacritty-bindings.5.gz"

	# shell completions
	install -Dm644 extra/completions/_alacritty     "$TERMUX_PREFIX/share/zsh/site-functions/_alacritty"
	install -Dm644 extra/completions/alacritty.bash "$TERMUX_PREFIX/share/bash-completion/completions/alacritty.bash"
	install -Dm644 extra/completions/alacritty.fish "$TERMUX_PREFIX/share/fish/vendor_completions.d/alacritty.fish"
}

termux_step_post_massage() {
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/expat-sys-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/freetype-sys-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/rustix-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/servo-fontconfig-sys-*
	rm -rf "$CARGO_HOME"/registry/src/index.crates.io-*/x11rb-protocol-*
}
