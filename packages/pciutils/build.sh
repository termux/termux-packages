TERMUX_PKG_HOMEPAGE=https://github.com/pciutils/pciutils
TERMUX_PKG_DESCRIPTION="library for portable access to PCI bus configuration registers and several utilities"
TERMUX_PKG_VERSION=3.5.5
TERMUX_PKG_SRCURL=https://github.com/pciutils/pciutils/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=07b9959d929248eeb274d8e8f7df33e2173f7eb7d49328a70366071f569fbade
TERMUX_PKG_MAINTAINER="Auxilus @Auxilus"
TERMUX_PKG_DEPENDS="libnl, libnl-dev, pkg-config"
TERMUX_PKG_BUILD_IN_SRC=yes

# packages are defaultly installed at $PREFIX/sbin so we have to move them to $PREFIX/bin
termux_step_post_configure () {

        sed 's|/usr/local|/data/data/com.termux/files/usr|g' -i Makefile

}
termux_step_post_make_install () {

        mv $TERMUX_PREFIX/sbin/* $TERMUX_PREFIX/bin/
        rm $TERMUX_PREFIX/sbin -rf
        
}
