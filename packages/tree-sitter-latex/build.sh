TERMUX_PKG_HOMEPAGE=https://github.com/latex-lsp/tree-sitter-latex
TERMUX_PKG_DESCRIPTION="LaTeX grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.6.0"
TERMUX_PKG_SRCURL=https://github.com/latex-lsp/tree-sitter-latex/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=90d2085c9a46f5da0918ead2fa9b764defd57c34d493f06160f796014d2fd16a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	termux_setup_nodejs
	termux_setup_treesitter
}

termux_step_make() {
	termux-tree-sitter generate
	termux-tree-sitter build
}

termux_step_make_install() {
	termux-tree-sitter install
}
