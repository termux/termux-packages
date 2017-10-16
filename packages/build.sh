TERMUX_PKG_HOMEPAGE=https://www.aircrack-ng.org
TERMUX_PKG_DESCRIPTION="an 802.11 WEP and WPA-PSK keys cracking program"
# TERMUX_PKG_VERSION=  not required 
TERMUX_PKG_SRCURL=https://Auxilus.github.io/aircrack-ng.tar.gz
TERMUX_PKG_SHA256=9992129ce2d3b5297e422e529a8230a6a449df9fec2edd04636d206c6851e7d5
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="libnl, libnl-dev" 
TERMUX_PKG_BUILD_IN_SRC=yes

# Some of the scripts such as `airmon-ng` are defaultly stored at sbin dir so we have to move them to $PREFIX/bin
termux_step_post_make_install () {

        mv $TERMUX_PREFIX/sbin/* $TERMUX_PREFIX/bin/
        rm $TERMUX_PREFIX/sbin -rf
        
}
