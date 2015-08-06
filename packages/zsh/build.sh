TERMUX_PKG_HOMEPAGE="http://www.zsh.org/"
TERMUX_PKG_DESCRIPTION="Shell designed for interactive use, although it is also a powerful scripting language"
TERMUX_PKG_VERSION=5.0.8
TERMUX_PKG_BUILD_REVISION=5
TERMUX_PKG_SRCURL="http://downloads.sourceforge.net/project/zsh/zsh/${TERMUX_PKG_VERSION}/zsh-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_RM_AFTER_INSTALL="bin/zsh-${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, termux-tools, command-not-found"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-etcdir=$TERMUX_PREFIX/etc --disable-gdbm --disable-pcre ac_cv_header_utmp_h=no"

termux_step_post_make_install () {
	# /etc/zshrc - Run for interactive shells (http://zsh.sourceforge.net/Guide/zshguide02.html):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-zshrc > $TERMUX_PREFIX/etc/zshrc
}
