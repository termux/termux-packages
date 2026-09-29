TERMUX_PKG_HOMEPAGE="https://github.com/tj/git-extras"
TERMUX_PKG_DESCRIPTION="Little git extras."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.5.0"
TERMUX_PKG_SRCURL=https://github.com/tj/git-extras/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bcfe0eabdccc806e53a10130fed6fb02373720ddeb670eecc5cc84d041d79880
TERMUX_PKG_DEPENDS="bash, git, util-linux, gawk, findutils, ncurses-utils"
TERMUX_PKG_RECOMMENDS="curl, procps, rsync"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Directory where `make install` will place bash completion script
	export COMPL_DIR="$TERMUX_PREFIX/share/bash-completion/completions"
}

termux_step_make() {
	# `make` and `make install` does the same thing
	# So, this is an empty function
	:
}

termux_step_post_make_install() {
	install -Dm644 etc/bash_completion.sh "${TERMUX_PREFIX}/share/bash-completion/completions/git-extras"
	install -Dm644 etc/git-extras-completion.zsh "${TERMUX_PREFIX}/share/zsh/site-functions/_git-extras"
	install -Dm644 etc/git-extras.fish "$TERMUX_PREFIX"/share/fish/vendor_completions.d/git-extras.fish
}
