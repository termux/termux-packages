TERMUX_PKG_HOMEPAGE=hhttps://www.kernel.org/pub/software/network/ethtool/
TERMUX_PKG_DESCRIPTION="standard Linux utility for controlling network drivers and hardware, particularly for wired Ethernet devices"
TERMUX_PKG_VERSION=4.11 
TERMUX_PKG_SRCURL=https://www.kernel.org/pub/software/network/ethtool/ethtool-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9992129ce2d3b5297e422e529a8230a6a449df9fec2edd04636d206c6851e7d5
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="libnl, libnl-dev" 
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install () {

        mv $TERMUX_PREFIX/sbin/* $TERMUX_PREFIX/bin/
        rm $TERMUX_PREFIX/sbin -rf
        
}
