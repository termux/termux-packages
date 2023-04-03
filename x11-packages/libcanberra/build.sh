TERMUX_PKG_HOMEPAGE=http://0pointer.de/lennart/projects/libcanberra/
TERMUX_PKG_DESCRIPTION="libcanberra defines a simple abstract interface for playing event sounds."
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.30
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=http://0pointer.de/lennart/projects/libcanberra/libcanberra-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gstreamer, gtk3, harfbuzz, libcairo, libltdl, libvorbis, libx11, pango, pulseaudio"
TERMUX_PKG_RECOMMENDS="zenity"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gtk
--disable-tdb
"

termux_step_post_get_source() {
	# src/malloc.h prevents system <malloc.h> from being included
	if [ -e "src/malloc-private.h" ]; then
		termux_error_exit "src/malloc-private.h already exists."
	fi
	mv src/malloc.h src/malloc-private.h
	find src -name 'Makefile.*' -o -name '*.c' | xargs -n 1 \
		sed -i 's/malloc\.h/malloc-private.h/g'
}
