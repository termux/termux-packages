TERMUX_PKG_HOMEPAGE=http://bochs.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Bochs is a highly portable open source IA-32 (x86) PC emulator and debugger written in C++."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.8
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/bochs/bochs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a85b13aff7d8411f7a9f356ba6c33b5f5dc1fbb107eb5018cc23a62639da0059
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
--enable-usb-ohci
--enable-ne2000
--enable-e1000
--enable-clgd54xx
--enable-voodoo
"
