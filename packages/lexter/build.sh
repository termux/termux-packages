TERMUX_PKG_HOMEPAGE=https://www.kyne.com.au/~mark/software/lexter.php
TERMUX_PKG_DESCRIPTION="A real-time word puzzle for text terminals"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=1.0.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://www.kyne.com.au/~mark/software/download/lexter-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b61a28fd5249b7d6c0df9be91c97c2acd00ccd9ad1e7b0c99808f6cdc96d5188
TERMUX_PKG_DEPENDS="ncurses, gettext"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--datadir=$TERMUX_PREFIX/share/lexter"
TERMUX_PKG_GROUPS="games"

termux_step_pre_configure() {
	autoreconf -vfi
}
