TERMUX_PKG_HOMEPAGE=https://lesspipe.org/
TERMUX_PKG_DESCRIPTION="An input filter for the pager less"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.23"
TERMUX_PKG_SRCURL=https://github.com/wofr06/lesspipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=89b255a20a2f9a9b0145a297006487eec1a08ca68c073d21e6e5b9179ec86d16
TERMUX_PKG_DEPENDS="file, less"
TERMUX_PKG_BUILD_DEPENDS="bash-completion"
TERMUX_PKG_SUGGESTS="7zip | p7zip, imagemagick, perl, unrar, unzip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_configure() {
	./configure \
		--prefix="$TERMUX_PREFIX" \
		--bash-completion-dir="${TERMUX_PREFIX}/share/bash-completion/completions" \
		--zsh-completion-dir="${TERMUX_PREFIX}/share/zsh/site-functions"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/etc/profile.d
	echo "export LESSOPEN='|$TERMUX_PREFIX/bin/lesspipe.sh %s'" \
		> "$TERMUX_PREFIX"/etc/profile.d/lesspipe.sh
	ln -sf "$TERMUX_PREFIX/bin/lesspipe.sh" "$TERMUX_PREFIX/bin/lesspipe"
}
