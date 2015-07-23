TERMUX_PKG_HOMEPAGE=http://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer implementing switching between several programs in one terminal, detaching them and reattaching them to a different terminal"
TERMUX_PKG_DEPENDS="ncurses, libevent"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tmux/tmux/tmux-${TERMUX_PKG_VERSION}/tmux-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/tmux.conf $TERMUX_PREFIX/etc/tmux.conf
}
