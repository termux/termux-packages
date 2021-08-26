TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_SUBPKG_DEPENDS="glib, libbz2, libc++, libcurl, libgnutls, libiconv, libjpeg-turbo, liblzo, libnettle, libnfs, libpixman, libpng, libspice-server, libssh, libusb, libusbredir, libx11, ncurses, qemu-common, resolv-conf, sdl2, sdl2-image, zlib, zstd"
TERMUX_SUBPKG_CONFLICTS="qemu-system-ppc64-headless"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-ppc64
share/man/man1/qemu-system-ppc64.1.gz
"
