TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator (arm)"
TERMUX_SUBPKG_DEPENDS="capstone, dtc, glib, libandroid-shmem, libbz2, libc++, libcurl, libgnutls, libjpeg-turbo, liblzo, libnettle, libnfs, libpixman, libpng, libsasl, libssh2, libxml2, ncurses, qemu-common, sdl2"

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-arm
share/man/man1/qemu-system-arm.1.gz"
