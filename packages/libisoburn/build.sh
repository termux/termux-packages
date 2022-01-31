TERMUX_PKG_HOMEPAGE=https://dev.lovelyhq.com/libburnia
TERMUX_PKG_DESCRIPTION="Frontend for libraries libburn and libisofs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.4
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://files.libburnia-project.org/releases/libisoburn-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2d89846d43880f17fa591c53b3bea42ffb803628e4e630c680fc2c9184f79132
TERMUX_PKG_DEPENDS="libburn, libisofs, readline"
TERMUX_PKG_CONFLICTS="xorriso"
TERMUX_PKG_BREAKS="libisoburn-dev"
TERMUX_PKG_REPLACES="libisoburn-dev"

# We don't have tk.
TERMUX_PKG_RM_AFTER_INSTALL="bin/xorriso-tcltk"
