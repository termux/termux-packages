TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A metapackage that provides commonly used treesitter parsers"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.0.4
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_METAPACKAGE=true
# Keep this list in sync with:
# https://github.com/neovim/neovim/blob/master/runtime/doc/treesitter.txt
# e.g. Neovim's `:h treesitter-parsers` help tag
#
TERMUX_PKG_DEPENDS="tree-sitter-c, tree-sitter-lua, tree-sitter-markdown, tree-sitter-query, tree-sitter-vimdoc, tree-sitter-vim"
