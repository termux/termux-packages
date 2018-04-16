TERMUX_PKG_HOMEPAGE=https://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer"
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
TERMUX_PKG_DEPENDS="ncurses, libevent, libutil, libandroid-support, libandroid-glob"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_SHA256=9ded7d100313f6bc5a87404a4048b3745d61f2332f99ec1400a7c4ed9485d452
TERMUX_PKG_SRCURL=https://github.com/tmux/tmux/releases/download/${TERMUX_PKG_VERSION}/tmux-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install () {
	cp $TERMUX_PKG_BUILDER_DIR/tmux.conf $TERMUX_PREFIX/etc/tmux.conf
}
