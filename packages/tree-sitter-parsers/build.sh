TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A metapackage that provides commonly used treesitter parsers"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.0.1
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_METAPACKAGE=true
# Keep this list in sync with:
# https://github.com/neovim/neovim/blob/master/runtime/doc/treesitter.txt
#
# Note: Python and Bash parsers were dropped by Neovim in 0.10.1,
# but treesitter.txt is not yet updated to reflect this.
TERMUX_PKG_DEPENDS="tree-sitter-c, tree-sitter-lua, tree-sitter-markdown, tree-sitter-query, tree-sitter-vimdoc, tree-sitter-vim"
