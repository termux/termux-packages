TERMUX_PKG_HOMEPAGE=https://kampfkarren.github.io/selene/
TERMUX_PKG_DESCRIPTION="A blazing-fast modern Lua linter written in Rust"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="0.31.0"
TERMUX_PKG_SRCURL="https://github.com/Kampfkarren/selene/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=fa3ef29ce2b698714b7dac6b27ea7b19feaeccf016b0f5e6f328113702be6f04
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make_install() {
	cargo install \
		--path selene \
		--bin selene \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--force \
		--locked \
		--no-track \
		--target "$CARGO_TARGET_NAME" \
		--root "$TERMUX_PREFIX"
}

termux_step_post_make_install() {
	# cargo install also drops a .crates.toml/.crates2.json receipt in
	# $TERMUX_PREFIX - not wanted in the package.
	rm -f "${TERMUX_PREFIX}/.crates.toml" "${TERMUX_PREFIX}/.crates2.json"
}
