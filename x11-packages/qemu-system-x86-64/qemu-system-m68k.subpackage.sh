TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_SUBPKG_DEPEND_ON_PARENT=deps
TERMUX_SUBPKG_CONFLICTS="qemu-system-m68k-headless"

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-m68k
share/man/man1/qemu-system-m68k.1.gz
"
