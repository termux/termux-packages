TERMUX_SUBPKG_DESCRIPTION="A set of utilities for working with the QEMU emulators"
TERMUX_SUBPKG_DEPENDS="capstone, glib, libandroid-shmem, libbz2, libc++, libcurl, libgnutls, libnettle, libnfs, libssh2, libxml2"

TERMUX_SUBPKG_INCLUDE="
bin/qemu-img
bin/qemu-io
bin/qemu-nbd
share/man/man1/qemu-img.1.gz"
