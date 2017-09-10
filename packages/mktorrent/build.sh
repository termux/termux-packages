
TERMUX_PKG_HOMEPAGE=http://mktorrent.sourceforge.net
TERMUX_PKG_DESCRIPTION="command line utility to create BitTorrent metainfo files"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://github.com/Rudde/mktorrent/archive/v${TERMUX_PKG_VERSION}.tar.gz
#TERMUX_PKG_SHA256=564072e633da3243252c3eb2cd005e406c005e0e4bbff56b22f7ae0640a3ee34
TERMUX_PKG_FOLDERNAME=mktorrent-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="clang, make" 
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure () {
	return
}

termux_step_make () {
        
          cd $TERMUX_PKG_SRCDIR
          make
          make install
} 

termux_step_make_install () {
	return
}
