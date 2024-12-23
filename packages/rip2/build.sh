TERMUX_PKG_HOMEPAGE=https://github.com/MilesCranmer/rip2
TERMUX_PKG_DESCRIPTION="A safe and ergonomic alternative to rm"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL="https://github.com/MilesCranmer/rip2/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e35733235589ad74bafce32f5ec0e5db71133eaa8373734763ae1f78ce5402cd
TERMUX_PKG_BREAKS="rip"
TERMUX_PKG_REPLACES="rip"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs "$TERMUX_PKG_MAKE_PROCESSES" --target "$CARGO_TARGET_NAME" --release
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" "target/${CARGO_TARGET_NAME}/release/rip"

	# shell completions
	mkdir -p "${TERMUX_PREFIX}/share/zsh/site-functions"
	mkdir -p "${TERMUX_PREFIX}/share/bash-completion/completions"
	mkdir -p "${TERMUX_PREFIX}/share/fish/vendor_completions.d"
	mkdir -p "${TERMUX_PREFIX}/share/elvish/lib"
	mkdir -p "${TERMUX_PREFIX}/share/nushell/vendor/autoload"
	cargo run -- completions    zsh > "${TERMUX_PREFIX}/share/zsh/site-functions/_${TERMUX_PKG_NAME}"
	cargo run -- completions   bash > "${TERMUX_PREFIX}/share/bash-completion/completions/${TERMUX_PKG_NAME}"
	cargo run -- completions   fish > "${TERMUX_PREFIX}/share/fish/vendor_completions.d/${TERMUX_PKG_NAME}.fish"
	cargo run -- completions elvish > "${TERMUX_PREFIX}/share/elvish/lib/${TERMUX_PKG_NAME}.elv"
	cargo run -- completions     nu > "${TERMUX_PREFIX}/share/nushell/vendor/autoload/${TERMUX_PKG_NAME}.nu"
}
