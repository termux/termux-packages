TERMUX_PKG_HOMEPAGE=http://abook.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Abook is a text-based addressbook program designed to use with mutt mail client"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.6.0pre2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://abook.sourceforge.net/devel/abook-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=59d444504109dd96816e003b3023175981ae179af479349c34fa70bc12f6d385
TERMUX_PKG_DEPENDS="libandroid-support, ncurses, readline"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
