TERMUX_PKG_HOMEPAGE=https://writewithharper.com/
TERMUX_PKG_DESCRIPTION="Offline, privacy-first grammar checker. Fast, open-source, Rust-powered"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.8.0"
TERMUX_PKG_SRCURL="https://github.com/Automattic/harper/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=00acec037c8a50021665ba7f27e0a46a4a8a23357a0127d7d2531ca32c8a7333
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	cargo vendor
	find ./vendor \
		-mindepth 1 -maxdepth 1 -type d \
		! -wholename ./vendor/cc \
		-exec rm -rf '{}' \;

	local patch="$TERMUX_PKG_BUILDER_DIR/rust-cc-do-not-concatenate-all-the-CFLAGS.diff"
	local dir="vendor/cc"
	echo "Applying patch: $patch"
	patch -p1 -d "$dir" <"$patch"

	echo "" >>Cargo.toml
	echo '[patch.crates-io]' >>Cargo.toml
	echo "cc = { path = \"./vendor/cc\" }" >>Cargo.toml
}

termux_step_make() {
	cargo build --release --manifest-path $TERMUX_PKG_BUILDDIR/harper-ls/Cargo.toml --target "${CARGO_TARGET_NAME}"
}

termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/harper-ls "${TERMUX_PREFIX}"/bin/harper-ls
}
