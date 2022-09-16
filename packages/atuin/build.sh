TERMUX_PKG_HOMEPAGE=https://github.com/ellie/atuin
TERMUX_PKG_DESCRIPTION="Magical shell history"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="11.0.0"
TERMUX_PKG_SRCURL=https://github.com/ellie/atuin/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=29689906e3fd6bc680c60c3b2f41f756da5bd677a4f4aea3d26eff87f5bebac4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 src/shell/atuin.bash $TERMUX_PREFIX/share/bash-completion/completions/atuin.bash
	install -Dm600 src/shell/atuin.zsh $TERMUX_PREFIX/share/zsh/site-functions/_atuin
	install -Dm600 src/shell/atuin.fish $TERMUX_PREFIX/share/fish/vendor_completions.d/atuin.fish
}
