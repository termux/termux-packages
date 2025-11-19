TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_SUBPKG_DEPEND_ON_PARENT=deps
TERMUX_SUBPKG_CONFLICTS="qemu-system-riscv32-headless"

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-riscv32
share/man/man1/qemu-system-riscv32.1.gz
"
