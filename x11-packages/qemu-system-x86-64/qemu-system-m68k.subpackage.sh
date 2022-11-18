TERMUX_SUBPKG_DESCRIPTION="A generic and open source machine emulator and virtualizer"
TERMUX_SUBPKG_DEPENDS="glib, gtk3, libbz2, libc++, libcurl, libgnutls, libiconv, libjpeg-turbo, liblzo, libnettle, libnfs, libpixman, libpng, libspice-server, libssh, libusb, libusbredir, libx11, ncurses, pulseaudio, qemu-common, resolv-conf, sdl2, sdl2-image, zlib, zstd"
TERMUX_SUBPKG_CONFLICTS="qemu-system-m68k-headless"
TERMUX_SUBPKG_DEPEND_ON_PARENT=no

TERMUX_SUBPKG_INCLUDE="
bin/qemu-system-m68k
share/man/man1/qemu-system-m68k.1.gz
"
