TERMUX_SUBPKG_DESCRIPTION="A set common files used by the QEMU emulators"
TERMUX_SUBPKG_DEPENDS="glib, libbz2, libcap-ng, libcurl, libgmp, libgnutls, libnettle, libnfs, libpixman, libssh, zlib, zstd"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_BREAKS="qemu-system-x86-64 (<< 1:8.0.0), qemu-system-x86-64-headless (<< 1:8.0.0)"
TERMUX_SUBPKG_REPLACES="qemu-system-x86-64 (<< 1:8.0.0), qemu-system-x86-64-headless (<< 1:8.0.0)"

TERMUX_SUBPKG_INCLUDE="
bin/qemu-pr-helper
bin/qemu-storage-daemon
include
libexec/qemu-bridge-helper
libexec/virtfs-proxy-helper
share/applications
share/doc
share/icons
share/man/man1/qemu-storage-daemon.1.gz
share/man/man1/qemu.1.gz
share/man/man1/virtfs-proxy-helper.1.gz
share/man/man7
share/man/man8
share/qemu
"
