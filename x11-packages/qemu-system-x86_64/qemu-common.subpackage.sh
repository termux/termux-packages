TERMUX_SUBPKG_INCLUDE="
bin/qemu-pr-helper
libexec/qemu-bridge-helper
share/qemu
share/man/man1/qemu.1
share/man/man7/qemu-qmp-ref.7
share/man/man7/qemu-block-drivers.7
"

TERMUX_SUBPKG_DEPENDS="glib, libandroid-shmem, libc++, libgnutls, libnettle, libutil"
TERMUX_SUBPKG_DESCRIPTION="A set common files for the QEMU system emulators"
