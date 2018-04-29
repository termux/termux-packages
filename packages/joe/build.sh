TERMUX_PKG_HOMEPAGE=http://joe-editor.sourceforge.net
TERMUX_PKG_DESCRIPTION="Wordstar like text editor"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_CONFLICTS="jupp"
TERMUX_PKG_VERSION=4.6
TERMUX_PKG_SHA256=495a0a61f26404070fe8a719d80406dc7f337623788e445b92a9f6de512ab9de
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/joe-editor/files/JOE%20sources/joe-${TERMUX_PKG_VERSION}/joe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-termcap"
