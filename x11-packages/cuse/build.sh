TERMUX_PKG_HOMEPAGE=https://pi4.informatik.uni-mannheim.de/~haensel/cuse/
TERMUX_PKG_DESCRIPTION="A MIDI-Sequencer which targets both terminal purists and visually impaired people"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/cuse/cuse-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_SHA256=dc2306c68eeb0eefb2da4739cf42bf3bf49fde3adba6ca58900fb3f78d4f9ad6
TERMUX_PKG_DEPENDS="libc++, libcdk, ncurses, sdl, sdl-mixer"

termux_step_post_get_source() {
	make distclean || :
}

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -lSDL"
}
