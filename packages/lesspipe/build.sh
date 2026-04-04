TERMUX_PKG_HOMEPAGE=https://lesspipe.org/
TERMUX_PKG_DESCRIPTION="An input filter for the pager less"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="2.24"
TERMUX_PKG_SRCURL=https://github.com/wofr06/lesspipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e8c3ac4c5954252ab72ae9e70d28ca1dff866b193a713bc67e2ad9f37ff6cec3
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
