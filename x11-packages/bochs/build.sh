TERMUX_PKG_HOMEPAGE=http://bochs.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Bochs is a highly portable open source IA-32 (x86) PC emulator and debugger written in C++."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/bochs/bochs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a010ab1bfdc72ac5a08d2e2412cd471c0febd66af1d9349bc0d796879de5b17a
TERMUX_PKG_DEPENDS="glib, gtk2, libc++, libx11, libxpm, libxrandr, ncurses, pango, readline"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_strtouq=no
--without-wx
--with-x11
--with-x
--with-term
--disable-docbook
--enable-x86-64
--enable-smp
--enable-debugger
--enable-disasm
--enable-3dnow
--enable-avx
--enable-usb
--enable-usb-ehci
--enable-ne2000
--enable-e1000
--enable-clgd54xx
--enable-voodoo
"
