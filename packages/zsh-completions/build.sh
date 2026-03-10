TERMUX_PKG_HOMEPAGE=https://github.com/zsh-users/zsh-completions
TERMUX_PKG_DESCRIPTION="Additional completion definitions for Zsh"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.36.0"
TERMUX_PKG_SRCURL=https://github.com/zsh-users/zsh-completions/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5aa68be2999a7be2eb56de8e4acff8f3bba4a66b9acbb233752536857408fb2e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS=zsh
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm644 src/* -t "$TERMUX_PREFIX/share/zsh/site-functions"
}
