TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/hyperfine
TERMUX_PKG_DESCRIPTION="A command-line benchmarking tool"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.0.0"
TERMUX_PKG_SRCURL="https://github.com/sharkdp/hyperfine/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=f4b71df3c78e4cf752ca6fb6ebc4b025f7ea6a5ca5c48fea75f8a1fdb4c7d721
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--release \
		--target "$CARGO_TARGET_NAME"
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" \
		"target/$CARGO_TARGET_NAME/release/hyperfine"
}

termux_step_post_make_install() {
	# Manpages.
	install -Dm600 doc/"${TERMUX_PKG_NAME}".1 \
		"${TERMUX_PREFIX}"/share/man/man1/"${TERMUX_PKG_NAME}".1

	# Shell completions.
	install -Dm600 target/"${CARGO_TARGET_NAME}"/release/build/"${TERMUX_PKG_NAME}"*/out/"${TERMUX_PKG_NAME}".bash \
		"${TERMUX_PREFIX}"/share/bash-completion/completions/"${TERMUX_PKG_NAME}".bash

	install -Dm600 target/"${CARGO_TARGET_NAME}"/release/build/"${TERMUX_PKG_NAME}"*/out/"${TERMUX_PKG_NAME}".fish \
		"${TERMUX_PREFIX}"/share/fish/vendor_completions.d/"${TERMUX_PKG_NAME}".fish

	install -Dm600 target/"${CARGO_TARGET_NAME}"/release/build/"${TERMUX_PKG_NAME}"*/out/_"${TERMUX_PKG_NAME}" \
		"${TERMUX_PREFIX}"/share/zsh/site-functions/_"${TERMUX_PKG_NAME}"
}
