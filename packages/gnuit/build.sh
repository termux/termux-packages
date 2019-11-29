TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gnuit/
TERMUX_PKG_DESCRIPTION="gnuit - GNU Interactive Tools"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_VERSION=4.9.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gnuit/gnuit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b6e96db13bafa5ad35c735b2277699d4244088c709a3e134fb1a3e8c8a8557c
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-transition"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"

termux_step_post_massage() {
	cd $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/gnuit
	ln -s gnuitrc.xterm-color gnuitrc.xterm-256color
	ln -s gnuitrc.screen gnuitrc.screen-color
	ln -s gnuitrc.screen gnuitrc.screen-256color
}
