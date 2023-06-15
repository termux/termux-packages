TERMUX_PKG_HOMEPAGE=https://dev.lovelyhq.com/libburnia
TERMUX_PKG_DESCRIPTION="Frontend for libraries libburn and libisofs"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.6
TERMUX_PKG_SRCURL=https://files.libburnia-project.org/releases/libisoburn-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2b80a6f73dd633a5d243facbe97a15e5c9a07644a5e1a242c219b9375a45f71b
TERMUX_PKG_DEPENDS="libburn, libisofs, readline"
TERMUX_PKG_CONFLICTS="xorriso"
TERMUX_PKG_BREAKS="libisoburn-dev"
TERMUX_PKG_REPLACES="libisoburn-dev"

# We don't have tk.
TERMUX_PKG_RM_AFTER_INSTALL="bin/xorriso-tcltk"
