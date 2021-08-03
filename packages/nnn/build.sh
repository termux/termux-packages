TERMUX_PKG_HOMEPAGE=https://github.com/jarun/nnn
TERMUX_PKG_DESCRIPTION="Free, fast, friendly file browser"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jarun/nnn/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5675f9fe53bddfd92681ef88bf6c0fab3ad897f9e74dd6cdff32fe1fa62c687f
TERMUX_PKG_DEPENDS="debianutils, file, findutils, readline, wget, libandroid-support, lzip"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 misc/auto-completion/bash/nnn-completion.bash \
		$TERMUX_PREFIX/share/bash-completions/nnn
	install -Dm600 misc/auto-completion/fish/nnn.fish \
		$TERMUX_PREFIX/share/fish/completions/nnn.fish
	install -Dm600 misc/auto-completion/zsh/_nnn \
		$TERMUX_PREFIX/share/zsh/site-functions/_nnn
}

