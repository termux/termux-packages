TERMUX_PKG_HOMEPAGE=https://github.com/getzola/zola
TERMUX_PKG_DESCRIPTION="A fast static site generator in a single binary with everything built-in."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.0"
TERMUX_PKG_SRCURL="https://github.com/getzola/zola/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=75274ca54c97da2f24645568e2c7024f6661ce002e8f7e09d6cd30bae7b73b0a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust

	# clash with rust host build
	unset CFLAGS
}

termux_step_make() {
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--release
}

termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/zola "$TERMUX_PREFIX"/bin
}

termux_step_post_make_install() {
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	cargo run -- completion    zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	cargo run -- completion   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	cargo run -- completion   fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	cargo run -- completion elvish > "${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
}
