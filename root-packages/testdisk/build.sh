TERMUX_PKG_HOMEPAGE=https://www.cgsecurity.org/wiki/TestDisk
TERMUX_PKG_DESCRIPTION="Partition Recovery and File Undelete"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=7.1
TERMUX_PKG_SRCURL=https://www.cgsecurity.org/testdisk-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1413c47569e48c5b22653b943d48136cb228abcbd6f03da109c4df63382190fe
TERMUX_PKG_DEPENDS="libuuid, zlib, libjpeg-turbo, libiconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--bindir=$TERMUX_PREFIX/bin
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
--mandir=$TERMUX_PREFIX/share/man
--without-ewf
--without-ntfs3g
--without-ntfs
--without-reiserfs
CXXLIBS=-lncurses
"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
        make -j2 static
}
