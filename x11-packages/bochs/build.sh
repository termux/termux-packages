TERMUX_PKG_HOMEPAGE=http://bochs.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Bochs is a highly portable open source IA-32 (x86) PC emulator and debugger written in C++."
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_VERSION=2.6.11
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/bochs/bochs-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=63897b41fbbbdfb1c492d3c4dee1edb4224282a07bbdf442a4a68c19bcc18862
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk2, libc++, libcairo, libgraphite, libx11, libxpm, libxrandr, ncurses, pango, readline"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
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
