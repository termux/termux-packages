TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_SUBPKG_DEPENDS="attr, glib, libbz2, libc++, libcap-ng, libcurl, libgcrypt, libiconv, libjpeg-turbo, liblzo, libnfs, libpixman, libpng, libssh, libx11, ncurses, qemu-common, resolv-conf, sdl2, sdl2-image, zlib, libspice-server, libusbredir"
TERMUX_SUBPKG_CONFLICTS="qemu-system-aarch64-headless"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-aarch64
share/man/man1/qemu-system-aarch64.1.gz
"
