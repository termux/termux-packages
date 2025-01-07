TERMUX_SUBPKG_DESCRIPTION="A set of utilities for working with the QEMU emulators"
TERMUX_SUBPKG_DEPENDS="glib, libbz2, libcurl, libgmp, libgnutls, libnettle, libnfs, libpixman, libssh, zlib, zstd"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false

TERMUX_SUBPKG_INCLUDE="
bin/elf2dmp
bin/qemu-edid
bin/qemu-img
bin/qemu-io
bin/qemu-nbd
share/man/man1/qemu-img.1.gz
share/man/man8/qemu-nbd.8.gz
"
