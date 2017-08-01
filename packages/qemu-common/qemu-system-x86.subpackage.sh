TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-i386
bin/qemu-system-x86_64
share/qemu/acpi-dsdt.aml
share/qemu/bios.bin
share/qemu/bios-256k.bin
share/qemu/efi-*.rom
share/qemu/kvmvapic.bin
share/qemu/linuxboot.bin
share/qemu/linuxboot_dma.bin
share/qemu/multiboot.bin
share/qemu/pxe-*.rom
share/qemu/sgabios.bin
share/qemu/vgabios*.bin
"
TERMUX_SUBPKG_DESCRIPTION="Qemu emulator - x86 and x86_64 system emulation"
TERMUX_SUBPKG_DEPENDS="qemu-common"
