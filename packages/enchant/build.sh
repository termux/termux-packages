TERMUX_PKG_HOMEPAGE=https://abiword.github.io/enchant/
TERMUX_PKG_DESCRIPTION="Wraps a number of different spelling libraries and programs with a consistent interface."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.2
TERMUX_PKG_SRCURL=https://github.com/AbiWord/enchant/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d1917e069a5786cc6b13a1eea565cb531feaa6d100fd07dcefb2a41dadf3f611
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-relocatable" 
TERMUX_PKG_DEPENDS="aspell, glib, hunspell"

termux_step_post_get_source() {
	./bootstrap
}
