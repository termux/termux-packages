TERMUX_PKG_HOMEPAGE=https://github.com/BurntSushi/ripgrep
TERMUX_PKG_DESCRIPTION="Search tool like grep and The Silver Searcher"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=12.0.1
TERMUX_PKG_SRCURL=https://github.com/BurntSushi/ripgrep/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5be34aa77a36ac9d8f1297a0d97069e4653e03f61c67d192cee32944cd2b6329
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
