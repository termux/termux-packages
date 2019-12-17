TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator and virtualizer (headless)"
TERMUX_SUBPKG_DEPENDS="attr, glib, libbz2, libc++, libcap, libcurl, libandroid-shmem, libgcrypt, libiconv, libjpeg-turbo, liblzo, libnfs, libpixman, libpng, libssh, libxml2, ncurses, qemu-common, resolv-conf, zlib"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-i386
share/man/man1/qemu-system-i386.1.gz
"
