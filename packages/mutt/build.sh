TERMUX_PKG_HOMEPAGE=http://www.mutt.org/
TERMUX_PKG_DESCRIPTION="Mail client"
TERMUX_PKG_VERSION=1.5.23
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://bitbucket.org/mutt/mutt/downloads/mutt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-smtp --enable-imap --enable-pop --with-mailpath=$TERMUX_PREFIX/var/mail --with-ssl --enable-compressed"

termux_step_post_make_install () {
        cp $TERMUX_PKG_SRCDIR/doc/mutt.man $TERMUX_PREFIX/share/man/man1/mutt.1.man
}
