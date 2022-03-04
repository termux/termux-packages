TERMUX_PKG_HOMEPAGE=http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html
TERMUX_PKG_DESCRIPTION="An input filter for the pager less"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.04
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/wofr06/lesspipe/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b65ee79b7b51510e6f2097a22d3c7985805a53d9e33b0afdfe129f2a1f89cc23
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="less"
TERMUX_PKG_SUGGESTS="imagemagick, p7zip, unrar, unzip"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	./configure \
		--prefix="$TERMUX_PREFIX" \
		--yes
}

termux_step_post_make_install() {
	mkdir -p "$TERMUX_PREFIX"/etc/profile.d
	echo "export LESSOPEN='|$TERMUX_PREFIX/bin/lesspipe.sh %s'" \
		> "$TERMUX_PREFIX"/etc/profile.d/lesspipe.sh
}
