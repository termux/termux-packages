TERMUX_PKG_HOMEPAGE=https://www.cgsecurity.org/wiki/TestDisk
TERMUX_PKG_DESCRIPTION="Partition Recovery and File Undelete"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.2"
TERMUX_PKG_SRCURL=https://www.cgsecurity.org/testdisk-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f8343be20cb4001c5d91a2e3bcd918398f00ae6d8310894a5a9f2feb813c283f
TERMUX_PKG_DEPENDS="libuuid, zlib, libjpeg-turbo, libiconv, ncurses, libandroid-glob"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--bindir=$TERMUX_PREFIX/bin
--sysconfdir=$TERMUX_PREFIX/etc
--localstatedir=$TERMUX_PREFIX/var
--mandir=$TERMUX_PREFIX/share/man
--without-ewf
--without-ntfs3g
--without-ntfs
--without-reiserfs
"

termux_step_pre_configure() {
	export LIBS="-lncurses -landroid-glob"
}

termux_step_make() {
	make -j2 static
}
