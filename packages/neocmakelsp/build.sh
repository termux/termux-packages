TERMUX_PKG_HOMEPAGE=https://neocmakelsp.github.io/
TERMUX_PKG_DESCRIPTION="a cmake lsp based on tower-lsp and treesitter"
TERMUX_PKG_LICENSE=MIT
TERMUX_PKG_MAINTAINER=@termux
TERMUX_PKG_VERSION="0.10.0"
TERMUX_PKG_SRCURL=https://github.com/neocmakelsp/neocmakelsp/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=084f4e8605e0834c3ca85abd7460801dc22454f45f68557340d02642a4be3c72
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
