TERMUX_PKG_HOMEPAGE=https://github.com/ajeetdsouza/zoxide
TERMUX_PKG_DESCRIPTION="A faster way to navigate your filesystem"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.9"
TERMUX_PKG_SRCURL=https://github.com/ajeetdsouza/zoxide/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=eddc76e94db58567503a3893ecac77c572f427f3a4eabdfc762f6773abf12c63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	install -Dm644 contrib/completions/zoxide.bash "$TERMUX_PREFIX"/share/bash-completion/completions/zoxide
	install -Dm644 contrib/completions/_zoxide "$TERMUX_PREFIX"/share/zsh/site-functions/_zoxide
	install -Dm644 contrib/completions/zoxide.fish "$TERMUX_PREFIX"/share/fish/vendor_completions.d/zoxide.fish
	install -Dm644 contrib/completions/zoxide.nu "$TERMUX_PREFIX"/share/nushell/vendor/autoload/zoxide.nu
	install -Dm644 contrib/completions/zoxide.elv "$TERMUX_PREFIX"/share/elvish/lib/zoxide.elv
	install -Dm644 man/man1/*.1 -t "$TERMUX_PREFIX"/share/man/man1/
}
