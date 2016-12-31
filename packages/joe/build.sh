TERMUX_PKG_HOMEPAGE=http://www.sourceforge.net/projects/joe-editor
TERMUX_PKG_DESCRIPTION="JOE is a full featured terminal-based screen editor"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_VERSION=4.3
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/joe-editor/files/JOE%20sources/joe-${TERMUX_PKG_VERSION}/joe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_FOLDERNAME=joe-${TERMUX_PKG_VERSION}
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-termcap"

termux_step_post_extract_package () {                                                   
# rm -r $TERMUX_PKG_SRCDIR/joe/util                                      
return
}