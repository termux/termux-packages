TERMUX_PKG_HOMEPAGE="https://github.com/wfxr/csview"
TERMUX_PKG_DESCRIPTION="Pretty-printing CSV/TSV/xSV on terminal"
TERMUX_PKG_LICENSE="MIT, Apache-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL="$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7c5ae0ff515b97267a0d47b15783d77f6b14d057e7e6110127f19d1f7b61e291

TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --locked
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/csview
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
	install -Dm600 "completions/fish/csview.fish" "$TERMUX_PREFIX/share/fish/vendor_completions.d/csview.fish"
	install -Dm600 "completions/zsh/_csview" "$TERMUX_PREFIX/share/zsh/site-functions/_csview"
	install -Dm600 "completions/bash/csview.bash" "$TERMUX_PREFIX/share/bash-completion/completions/csview"

	# https://github.com/elves/elvish/issues/1564#issuecomment-1166333636
	install -Dm600 "completions/elvish/csview.elv" -t $TERMUX_PREFIX/share/elvish/lib
}
