TERMUX_PKG_HOMEPAGE=http://www-zeuthen.desy.de/~friebel/unix/lesspipe.html
TERMUX_PKG_DESCRIPTION="An input filter for the pager less"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.88
TERMUX_PKG_SRCURL=https://github.com/wofr06/lesspipe/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=442a178f40e0261144f03f1a31048e00d09c8d0fbd7107d99d183b54f10c7ac3
TERMUX_PKG_DEPENDS="less"
TERMUX_PKG_SUGGESTS="imagemagick, p7zip, unrar, unzip"
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
