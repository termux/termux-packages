TERMUX_PKG_HOMEPAGE=https://github.com/termux/termux-packages
TERMUX_PKG_DESCRIPTION="A metapackage that provides commonly used treesitter parsers"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=0.1.0
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_METAPACKAGE=true
# List of default parsers shipped with Neovim:
# https://github.com/neovim/neovim/blob/master/runtime/doc/treesitter.txt
# e.g. Neovim's `:h treesitter-parsers` help tag
TERMUX_PKG_DEPENDS="tree-sitter-c, "
TERMUX_PKG_DEPENDS+="tree-sitter-lua, "
TERMUX_PKG_DEPENDS+="tree-sitter-markdown, "
TERMUX_PKG_DEPENDS+="tree-sitter-query, "
TERMUX_PKG_DEPENDS+="tree-sitter-vimdoc, "
TERMUX_PKG_DEPENDS+="tree-sitter-vim, "
# Additional common parsers
TERMUX_PKG_DEPENDS+="tree-sitter-bash, "
TERMUX_PKG_DEPENDS+="tree-sitter-css, "
TERMUX_PKG_DEPENDS+="tree-sitter-go, "
TERMUX_PKG_DEPENDS+="tree-sitter-html, "
TERMUX_PKG_DEPENDS+="tree-sitter-java, "
TERMUX_PKG_DEPENDS+="tree-sitter-javascript, "
TERMUX_PKG_DEPENDS+="tree-sitter-json, "
TERMUX_PKG_DEPENDS+="tree-sitter-python, "
TERMUX_PKG_DEPENDS+="tree-sitter-regex, "
TERMUX_PKG_DEPENDS+="tree-sitter-rust, "
TERMUX_PKG_DEPENDS+="tree-sitter-sql, "
TERMUX_PKG_DEPENDS+="tree-sitter-toml, "
TERMUX_PKG_DEPENDS+="tree-sitter-xml, "
TERMUX_PKG_DEPENDS+="tree-sitter-yaml"
