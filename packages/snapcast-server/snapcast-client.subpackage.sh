TERMUX_SUBPKG_INCLUDE="
bin/snapclient
share/man/man1/snapclient.1.gz
share/pixmaps/snapcast.svg
"
TERMUX_SUBPKG_DESCRIPTION="A multiroom client-server audio player (client)"
TERMUX_SUBPKG_DEPENDS="avahi, pulseaudio"
TERMUX_SUBPKG_DEPEND_ON_PARENT=deps
