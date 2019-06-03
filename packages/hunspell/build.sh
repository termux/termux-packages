TERMUX_PKG_HOMEPAGE=https://hunspell.github.io
TERMUX_PKG_DESCRIPTION="Spell checker"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.7.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SHA256=bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a
TERMUX_PKG_SRCURL=https://github.com/hunspell/hunspell/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ui --with-readline"
TERMUX_PKG_DEPENDS="libiconv, ncurses, readline, hunspell-en-us"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	autoreconf -vfi
}
