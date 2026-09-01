TERMUX_PKG_HOMEPAGE=https://git-cliff.org
TERMUX_PKG_DESCRIPTION="A highly customizable changelog generator that follows Conventional Commit specifications"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="2.14.1"
TERMUX_PKG_SRCURL="https://github.com/orhun/git-cliff/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=22f01e016a02d674eb23afee3f0169a725352cc42d54549ecdb031e8f59e87e6
TERMUX_PKG_DEPENDS="libgit2, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	# system libraries link
	export LIBGIT2_NO_VENDOR=1
	export LIBZ_SYS_STATIC=0

	# cargo vendor run and extract only vendor/cc
	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		-exec rm -rf '{}' \;

	# apply patch with --ignore-whitespace to prevent line rejection
	local patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	local dir="vendor/cc"
	echo "Applying patch: $patch"
	patch -p1 --ignore-whitespace -d "$dir" < "$patch"

	# override cc crate in Cargo.toml
	echo "" >> Cargo.toml
	echo '[patch.crates-io]' >> Cargo.toml
	echo 'cc = { path = "./vendor/cc" }' >> Cargo.toml
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release \
		--package git-cliff
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/git-cliff"
}
