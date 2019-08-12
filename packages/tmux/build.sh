TERMUX_PKG_HOMEPAGE=https://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer"
TERMUX_PKG_LICENSE="BSD"
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
TERMUX_PKG_DEPENDS="ncurses, libevent, libutil, libandroid-support, libandroid-glob"
TERMUX_PKG_VERSION=2.9a
TERMUX_PKG_SHA256=839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25
TERMUX_PKG_SRCURL=https://github.com/tmux/tmux/releases/download/${TERMUX_PKG_VERSION}/tmux-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="etc/tmux.conf"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/tmux.conf $TERMUX_PREFIX/etc/tmux.conf

	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
	termux_download \
		https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux \
		$TERMUX_PREFIX/share/bash-completion/completions/tmux \
		05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae
}
