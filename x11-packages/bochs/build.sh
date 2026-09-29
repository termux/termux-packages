TERMUX_PKG_HOMEPAGE=http://bochs.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Bochs is a highly portable open source IA-32 (x86) PC emulator and debugger written in C++."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/bochs/bochs-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=14aaf78dbe1337987923fffc4e7a962ae56abcf9a87474ace39e593f9f84ee84
TERMUX_PKG_DEPENDS="glib, gtk3, libc++, libx11, libxpm, libxrandr, ncurses, pango, readline"
TERMUX_PKG_AUTO_UPDATE=true

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
--enable-evex
--enable-usb
--enable-usb-ehci
--enable-usb-ohci
--enable-ne2000
--enable-e1000
--enable-clgd54xx
--enable-voodoo
"
