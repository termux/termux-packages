TERMUX_PKG_HOMEPAGE=http://bochs.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Bochs is a highly portable open source IA-32 (x86) PC emulator and debugger written in C++."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.6.9
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/bochs/bochs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ee5b677fd9b1b9f484b5aeb4614f43df21993088c0c0571187f93acb0866e98c
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk2, pango-x, libandroid-shmem, libc++, libcairo-x, libgraphite, libx11, libxpm, libxrandr, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--without-wx
--with-x11
--with-x
--with-term
--disable-docbook
--enable-cpu-level=6
--enable-fpu
--enable-3dnow
--enable-disasm
--enable-smp
--enable-x86-64
--enable-avx
--enable-long-phy-address
--enable-disasm
--enable-usb
--enable-debugger
--disable-readline
"