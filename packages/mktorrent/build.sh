
TERMUX_PKG_HOMEPAGE=http://mktorrent.sourceforge.net
TERMUX_PKG_DESCRIPTION="command line utility to create BitTorrent metainfo files"
TERMUX_PKG_VERSION=1.1
TERMUX_PKG_SRCURL=https://github.com/Rudde/mktorrent/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0f47500192605d01b5a2569c605e51ed319f557d24cfcbcb23a26d51d6138c9
TERMUX_PKG_FOLDERNAME=mktorrent-$TERMUX_PKG_VERSION
TERMUX_PKG_DEPENDS="clang, make" 
TERMUX_PKG_BUILD_IN_SRC=yes
