TERMUX_PKG_HOMEPAGE="https://kbd-project.org/"
TERMUX_PKG_DESCRIPTION="KBD's showkey utility for examining keycodes"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.4
TERMUX_PKG_SRCURL=https://mirrors.edge.kernel.org/pub/linux/utils/kbd/kbd-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=99b2a39e1c5475ffe8e1bb2004345cb8849c3cc1aedbe541beee2d45e270975f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-vlock"

# We're only keeping:
# bin/showkey
# share/doc/kbd/LICENSE
# share/man/man1/showkey.1.gz

TERMUX_PKG_RM_AFTER_INSTALL='
bin/unicode_stop bin/kbd_mode bin/deallocvt bin/fgconsole bin/getkeycodes
bin/setvtrgb bin/openvt bin/psfgettable bin/setmetamode bin/setleds
bin/chvt bin/unicode_start bin/psfstriptable bin/dumpkeys bin/kbdrate
bin/setfont bin/psfaddtable bin/mapscrn bin/kbdinfo bin/setkeycodes
bin/showconsolefont bin/loadkeys bin/psfxtable bin/loadunimap

share/man/man5 share/man/man8
share/man/man1/loadkeys.1 share/man/man1/fgconsole.1
share/man/man1/setmetamode.1 share/man/man1/psfstriptable.1
share/man/man1/dumpkeys.1 share/man/man1/unicode_start.1
share/man/man1/chvt.1 share/man/man1/psfaddtable.1
share/man/man1/psfxtable.1 share/man/man1/unicode_stop.1
share/man/man1/openvt.1 share/man/man1/psfgettable.1
share/man/man1/kbd_mode.1 share/man/man1/deallocvt.1
share/man/man1/setleds.1 share/man/man1/kbdinfo.1

share/consolefonts share/consoletrans
share/keymaps share/unimaps
'
