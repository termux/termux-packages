TERMUX_PKG_HOMEPAGE=http://joe-editor.sourceforge.net
TERMUX_PKG_DESCRIPTION="Wordstar like text editor"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="jupp"
TERMUX_PKG_VERSION=4.5
TERMUX_PKG_SHA256=51104aa34d8650be3fa49f2204672a517688c9e6ec47e68f1ea85de88e36cadf
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/joe-editor/files/JOE%20sources/joe-${TERMUX_PKG_VERSION}/joe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-termcap"
