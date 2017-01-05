TERMUX_PKG_HOMEPAGE=http://joe-editor.sourceforge.net
TERMUX_PKG_DESCRIPTION="Wordstar like text editor"
TERMUX_PKG_DEPENDS="ncurses, libutil"
TERMUX_PKG_VERSION=4.3
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/joe-editor/files/JOE%20sources/joe-${TERMUX_PKG_VERSION}/joe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=985d6a8f943a06e64165996c24d7fecaeae8c59efb52998a49b3fb4b8a3e26e1
TERMUX_PKG_FOLDERNAME=joe-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-termcap"
