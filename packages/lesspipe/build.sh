TERMUX_PKG_HOMEPAGE=http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html
TERMUX_PKG_DESCRIPTION="An input filter for the pager less"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION="2.16"
TERMUX_PKG_SRCURL=https://github.com/wofr06/lesspipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=18687fb0f416e2ec91a387b3159f84deba97d21d41ec89e72e7d5a1bf8ff9c01
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="less"
TERMUX_PKG_BUILD_DEPENDS="bash-completion"
TERMUX_PKG_SUGGESTS="imagemagick, p7zip, unrar, unzip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure \
		--prefix="$TERMUX_PREFIX"
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/etc/profile.d
	echo "export LESSOPEN='|$TERMUX_PREFIX/bin/lesspipe.sh %s'" \
		> "$TERMUX_PREFIX"/etc/profile.d/lesspipe.sh
	ln -sf "$TERMUX_PREFIX/bin/lesspipe.sh" "$TERMUX_PREFIX/bin/lesspipe"
}
