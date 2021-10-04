TERMUX_PKG_HOMEPAGE=https://tmux.github.io/
TERMUX_PKG_DESCRIPTION="Terminal multiplexer"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
# Link against libandroid-support for wcwidth(), see https://github.com/termux/termux-packages/issues/224
TERMUX_PKG_DEPENDS="ncurses, libevent, libandroid-support, libandroid-glob"
TERMUX_PKG_VERSION=3.2a
TERMUX_PKG_SRCURL=https://github.com/tmux/tmux/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=497bc4ee16f10b53b161bf0253b6f9e20cd0f86c5d0104f149212cb0778ae13a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_CONFFILES="etc/tmux.conf"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
	./autogen.sh
}

termux_step_post_make_install() {
	cp $TERMUX_PKG_BUILDER_DIR/tmux.conf $TERMUX_PREFIX/etc/tmux.conf

	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
	termux_download \
		https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux \
		$TERMUX_PREFIX/share/bash-completion/completions/tmux \
		05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "mkdir -p $TERMUX_PREFIX/var/run" >> postinst
}
