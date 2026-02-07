TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A metapackage that provides commonly used treesitter parsers"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_METAPACKAGE=true

# List of default parsers shipped with Neovim:
# https://github.com/neovim/neovim/blob/master/runtime/doc/treesitter.txt
# e.g. Neovim's `:h treesitter-parsers` help tag
TERMUX_PKG_DEPENDS="tree-sitter-c, tree-sitter-lua, tree-sitter-markdown, tree-sitter-query, tree-sitter-vimdoc, tree-sitter-vim"

# Installed by default but considered optional to the metapackage.
TERMUX_PKG_RECOMMENDS="tree-sitter-bash, tree-sitter-css, tree-sitter-go, tree-sitter-html, tree-sitter-latex, tree-sitter-java, tree-sitter-javascript, tree-sitter-json, tree-sitter-python, tree-sitter-regex, tree-sitter-rust, tree-sitter-sql, tree-sitter-toml, tree-sitter-xml, tree-sitter-yaml"
