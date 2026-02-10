TERMUX_PKG_HOMEPAGE=https://github.com/facebook/pyrefly.git
TERMUX_PKG_DESCRIPTION="A fast type checker and language server for Python"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@AhmadNaruto"
TERMUX_PKG_VERSION="0.52.0"
TERMUX_PKG_SRCURL="https://github.com/facebook/pyrefly/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c07db9efc130e7ecda097cd12c98c30c7189ccb011585a31fb204ca0a7d449f2
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

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
	test -f "$patch"
	patch -p1 -d "$dir" < "$patch"

	sed -i '/\[patch.crates-io\]/a cc = { path = "./vendor/cc" }' Cargo.toml
}

termux_step_make() {
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/pyrefly"
}
