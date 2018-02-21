TERMUX_PKG_HOMEPAGE=https://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer"
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
TERMUX_PKG_DEPENDS="ncurses, libevent, libutil, libandroid-support, libandroid-glob"
TERMUX_PKG_VERSION=2.6
TERMUX_PKG_SHA256=b17cd170a94d7b58c0698752e1f4f263ab6dc47425230df7e53a6435cc7cd7e8
TERMUX_PKG_SRCURL=https://github.com/tmux/tmux/releases/download/${TERMUX_PKG_VERSION}/tmux-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/tmux.conf $TERMUX_PREFIX/etc/tmux.conf
}
