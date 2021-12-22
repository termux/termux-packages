TERMUX_SUBPKG_DESCRIPTION="A set common files used by the QEMU emulators"
TERMUX_SUBPKG_DEPENDS="glib, libgcrypt"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no

TERMUX_SUBPKG_INCLUDE="
bin/qemu-pr-helper
bin/qemu-storage-daemon
libexec/virtfs-proxy-helper
libexec/qemu-bridge-helper
share/applications
share/icons
share/doc
share/man/man1/qemu.1.gz
share/man/man1/virtfs-proxy-helper.1.gz
share/man/man7
share/man/man8
share/qemu
"
