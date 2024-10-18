TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/zoxide
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.6"
TERMUX_PKG_SRCURL=https://github.com/ajeetdsouza/zoxide/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e1811511a4a9caafa18b7d1505147d4328b39f6ec88b88097fe0dad59919f19c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	rm -f ./Makefile
}

termux_step_post_make_install() {
	install -Dm644 contrib/completions/zoxide.bash "$TERMUX_PREFIX"/share/bash-completion/completions/zoxide
	install -Dm644 contrib/completions/_zoxide "$TERMUX_PREFIX"/share/zsh/site-functions/_zoxide
	install -Dm644 contrib/completions/zoxide.fish "$TERMUX_PREFIX"/share/fish/vendor_completions.d/zoxide.fish
	install -Dm644 man/man1/*.1 -t "$TERMUX_PREFIX"/share/man/man1/
}
