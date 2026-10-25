TERMUX_PKG_HOMEPAGE=https://numbat.dev/
TERMUX_PKG_DESCRIPTION="A statically typed programming language for scientific computations with first class support for physical dimensions and units"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_MAINTAINER="Gouranga Das Samrat <gouranga.das.khulna@gmail.com>"
TERMUX_PKG_VERSION="1.24.0"
TERMUX_PKG_SRCURL="https://github.com/sharkdp/numbat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=03c84d1d30bce73f2fcbfa79c8df51e580293918fef9c35966b158eaae234a08
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make_install() {
	cargo install \
		--path numbat-cli \
		--bin numbat \
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
