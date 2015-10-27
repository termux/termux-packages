TERMUX_PKG_HOMEPAGE="http://www.zsh.org/"
TERMUX_PKG_DESCRIPTION="Shell designed for interactive use, although it is also a powerful scripting language"
TERMUX_PKG_VERSION=5.1.1
TERMUX_PKG_BUILD_REVISION=2
TERMUX_PKG_SRCURL=http://www.zsh.org/pub/zsh-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_RM_AFTER_INSTALL="bin/zsh-${TERMUX_PKG_VERSION}"
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, termux-tools, command-not-found"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-etcdir=$TERMUX_PREFIX/etc --disable-gdbm --disable-pcre ac_cv_header_utmp_h=no"

termux_step_post_make_install () {
	# /etc/zshrc - Run for interactive shells (http://zsh.sourceforge.net/Guide/zshguide02.html):
	sed "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" $TERMUX_PKG_BUILDER_DIR/etc-zshrc > $TERMUX_PREFIX/etc/zshrc

	# Remove zsh.new/zsh.old/zsh-$version if any exists:
	rm -f $TERMUX_PREFIX/{zsh-*,zsh.*}

	# This should perhaps be done in a more general way? Doing it here
	# to silence "compaudit" warnings:
	chmod 700 $TERMUX_PREFIX/share/{zsh,zsh/$TERMUX_PKG_VERSION}
}

termux_step_create_debscripts () {
	# For already installed packages:
	echo "chmod 700 $TERMUX_PREFIX/share/{zsh,zsh/$TERMUX_PKG_VERSION}" > postinst
        echo "exit 0" >> postinst
        chmod 0755 postinst
}
