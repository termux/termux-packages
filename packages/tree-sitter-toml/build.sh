TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars/tree-sitter-toml
TERMUX_PKG_DESCRIPTION="TOML grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="0.7.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-toml/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7d52a7d4884f307aabc872867c69084d94456d8afcdc63b0a73031a8b29036dc
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
