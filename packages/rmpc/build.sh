TERMUX_PKG_HOMEPAGE="https://mierak.github.io/rmpc/"
TERMUX_PKG_DESCRIPTION="A configurable TUI MPD client with album art support"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL="https://github.com/mierak/rmpc/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=930019066228d18e9530a8c0d77f10e231ab5efbbbca73b331efcd6fbb47557d
TERMUX_PKG_SUGGESTS="cava, ffmpeg, python-yt-dlp"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --locked
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/rmpc

	install -Dm 644 "target/completions/rmpc.bash" -t "$TERMUX_PREFIX/share/bash-completion/completions/"
	install -Dm 644 "target/completions/rmpc.fish" -t "$TERMUX_PREFIX/share/fish/vendor_completions.d/"
	install -Dm 644 "target/completions/_rmpc" -t "$TERMUX_PREFIX/share/zsh/site-functions/"
	install -Dm 644 "target/man/rmpc.1" "$TERMUX_PREFIX/share/man/man1/rmpc.1"
}
