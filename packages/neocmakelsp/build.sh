TERMUX_PKG_HOMEPAGE=https://neocmakelsp.github.io/
TERMUX_PKG_DESCRIPTION="a cmake lsp based on tower-lsp and treesitter"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="0.8.26"
TERMUX_PKG_SRCURL=https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a400e86420cc7d67008a2139c3d7d9853b2775ffb5b6c53964775ffb505e5a36
TERMUX_PKG_DEPENDS="cmake"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_rust

	rm -f meson.build
}

termux_step_post_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}/share/bash-completion/completions" completions/bash/neocmakelsp
	install -Dm600 -t "${TERMUX_PREFIX}/share/fish/vendor_completions.d" completions/fish/neocmakelsp.fish
	install -Dm600 -t "${TERMUX_PREFIX}/share/zsh/site-functions" completions/zsh/_neocmakelsp
}
