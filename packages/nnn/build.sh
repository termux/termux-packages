TERMUX_PKG_HOMEPAGE=https://github.com/jarun/nnn
TERMUX_PKG_DESCRIPTION="Free, fast, friendly file browser"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="5.2"
TERMUX_PKG_SRCURL=https://github.com/jarun/nnn/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f166eda5093ac8dcf8cbbc6224123a32c53cf37b82c5c1cb48e2e23352754030
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="file, findutils, readline, wget, libandroid-support, lzip"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 misc/auto-completion/bash/nnn-completion.bash \
		$TERMUX_PREFIX/share/bash-completion/completions/nnn
	install -Dm600 misc/auto-completion/fish/nnn.fish \
		$TERMUX_PREFIX/share/fish/vendor_completions.d/nnn.fish
	install -Dm600 misc/auto-completion/zsh/_nnn \
		$TERMUX_PREFIX/share/zsh/site-functions/_nnn
}
