TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:3.1.0"
: "${TERMUX_PKG_VERSION:2}" # We need to remove both the epoch and the '~' from the version
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/refs/tags/v${_//\~/-}.tar.gz
TERMUX_PKG_SHA256=d07d22d9531fa98d2999dfc2ef27651efc3a4f5e5f46a78c3c306b69c466af8b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	# Clean up any previous compiler output for repeated builds.
	rm -rf "target/${CARGO_TARGET_NAME}/release/build/"asciinema-*

	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/asciinema"

	# Man pages
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1" "target/${CARGO_TARGET_NAME}/release/build/"asciinema-*/out/man/*

	# Shell completions
	install -Dm600 -t "${TERMUX_PREFIX}/share/bash-completion/completions" "target/${CARGO_TARGET_NAME}/release/build/"asciinema-*/out/completion/asciinema.bash
	install -Dm600 -t "${TERMUX_PREFIX}/share/fish/vendor_completions.d" "target/${CARGO_TARGET_NAME}/release/build/"asciinema-*/out/completion/asciinema.fish
	install -Dm600 -t "${TERMUX_PREFIX}/share/elvish/lib" "target/${CARGO_TARGET_NAME}/release/build/"asciinema-*/out/completion/asciinema.elv
	install -Dm600 -t "${TERMUX_PREFIX}/share/zsh/site-functions" "target/${CARGO_TARGET_NAME}/release/build/"asciinema-*/out/completion/_asciinema
}
