TERMUX_PKG_HOMEPAGE=https://github.com/BurntSushi/ripgrep
TERMUX_PKG_DESCRIPTION="Search tool like grep and The Silver Searcher"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=11.0.2
TERMUX_PKG_SHA256=0983861279936ada8bc7a6d5d663d590ad34eb44a44c75c2d6ccd0ab33490055
TERMUX_PKG_SRCURL=https://github.com/BurntSushi/ripgrep/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	# Install man page:
	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp $(find . -name rg.1) $TERMUX_PREFIX/share/man/man1/

	# Install bash completion script:
	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions/
	cp $(find . -name rg.bash) $TERMUX_PREFIX/share/bash-completion/completions/rg

	# Install fish completion script:
	mkdir -p $TERMUX_PREFIX/share/fish/completions/
	cp $(find . -name rg.fish) $TERMUX_PREFIX/share/fish/completions/

	# Install zsh completion script:
	mkdir -p $TERMUX_PREFIX/share/zsh/site-functions/
	cp complete/_rg $TERMUX_PREFIX/share/zsh/site-functions/
}
