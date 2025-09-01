TERMUX_PKG_HOMEPAGE=https://asciinema.org/
TERMUX_PKG_DESCRIPTION="Record and share your terminal sessions, the right way"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1:3.0.0~rc.5"
: "${TERMUX_PKG_VERSION:2}" # We need to remove both the epoch and the '~' from the version
TERMUX_PKG_SRCURL=https://github.com/asciinema/asciinema/archive/v${_//\~/-}.tar.gz
TERMUX_PKG_SHA256=31b56c062309316a961eb4fa86b73b7a478ac0a8c89ab44d978958e81a420dd0
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
