TERMUX_PKG_HOMEPAGE=http://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer implementing switching between several programs in one terminal, detaching them and reattaching them to a different terminal"
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
TERMUX_PKG_DEPENDS="ncurses, libevent, libutil, libandroid-support"
TERMUX_PKG_VERSION=2.3
TERMUX_PKG_SRCURL=https://github.com/tmux/tmux/releases/download/${TERMUX_PKG_VERSION}/tmux-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/tmux.conf $TERMUX_PREFIX/etc/tmux.conf
}
