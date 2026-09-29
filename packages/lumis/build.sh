TERMUX_PKG_HOMEPAGE=https://github.com/leandrocp/lumis
TERMUX_PKG_DESCRIPTION="Syntax Highlighter powered by Tree-sitter and Neovim themes"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.1
TERMUX_PKG_SRCURL=https://github.com/leandrocp/lumis/archive/refs/tags/hex-lumis/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8088fa9f22980cb7a842705da4282c5570947884d42c17813c160b6ed8c7d319
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="cmake, clang"

termux_step_make() {
	cargo build \
		--release \
		--jobs "$TERMUX_PKG_MAKE_PROCESSES" \
		--target "$CARGO_TARGET_NAME" \
		--locked \
		--package lumis-cli
}

termux_step_pre_configure() {
	termux_setup_rust
}
