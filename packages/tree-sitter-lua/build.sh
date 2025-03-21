TERMUX_PKG_HOMEPAGE=https://github.com/tree-sitter-grammars
TERMUX_PKG_DESCRIPTION="Lua grammar for tree-sitter"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.0"
TERMUX_PKG_SRCURL=https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a34cc70abfd8d2d4b0fabf01403ea05f848e1a4bc37d8a4bfea7164657b35d31
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE='newest-tag'
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
PARSER_URL=https://github.com/tree-sitter-grammars/tree-sitter-lua
"

termux_step_pre_configure() {
	rm setup.py pyproject.toml
}

termux_step_post_make_install() {
	install -d "${TERMUX_PREFIX}"/lib/tree_sitter
	ln -sf "${TERMUX_PREFIX}"/lib/libtree-sitter-lua.so "${TERMUX_PREFIX}"/lib/tree_sitter/lua.so
}
