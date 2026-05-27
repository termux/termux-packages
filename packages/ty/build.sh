TERMUX_PKG_HOMEPAGE=https://github.com/astral-sh/ty
TERMUX_PKG_DESCRIPTION="An extremely fast Python type checker and language server, written in Rust"
TERMUX_PKG_VERSION="0.0.40"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL="https://github.com/astral-sh/ty/releases/download/$TERMUX_PKG_VERSION/source.tar.gz"
TERMUX_PKG_SHA256=718121a6652dcf449eef25f800cabfd78592d382621cfbd0721f700b077e6d0e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

# The original "termux_extract_src_archive" always strips the first components
# but the source of ty is directly under the root directory of the tar file
termux_extract_src_archive() {
	local file="$TERMUX_PKG_CACHEDIR/$(basename "$TERMUX_PKG_SRCURL")"
	mkdir -p "$TERMUX_PKG_SRCDIR"
	tar -xf "$file" -C "$TERMUX_PKG_SRCDIR"
}

termux_step_pre_configure() {
	# when rust projects include a .cargo folder with their source code,
	# attempting to cross-compile that code for android usually results in
	# frustrating errors lke 'error: Missing manifest in toolchain '1.95-x86_64-unknown-linux-gnu',
	# varying depending on what content exactly was in .cargo.
	# deleting .cargo first before doing anything else usually seems to prevent that.
	rm -rf .cargo
	TERMUX_PKG_SRCDIR+="/ruff"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
	cd "$TERMUX_PKG_SRCDIR"

	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	local dir="vendor/cc"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" < "$patch"

	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo "cc = { path = \"./vendor/cc\" }" >> Cargo.toml
}

termux_step_make() {
	cargo build \
		--bin ty \
		--jobs "${TERMUX_PKG_MAKE_PROCESSES}" \
		--target "${CARGO_TARGET_NAME}" \
		--release
}

termux_step_make_install() {
	install -Dm755 \
		target/"${CARGO_TARGET_NAME}"/release/ty \
		"$TERMUX_PREFIX"/bin/ty
}
