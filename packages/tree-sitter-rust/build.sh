TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter/tree-sitter-rust
TERMUX_PKG_DESCRIPTION="Rust grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.24.1"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter/tree-sitter-rust/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5817812a95d147f6afa825e43a5917e41622b69f4039c2deeda003f4c48d8611
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
