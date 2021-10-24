TERMUX_PKG_HOMEPAGE=http://atterer.org/jigdo/
TERMUX_PKG_DESCRIPTION="Distribute large images by sending and receiving the files that make them up"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.8.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://www.einval.com/~steve/software/jigdo/download/jigdo-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=f253f72b5719716a7f039877a97ebaf4ba96e877510fca0fb42010d0793db6a4
TERMUX_PKG_DEPENDS="libbz2, libc++, libdb, wget, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--without-gui
"

termux_step_pre_configure() {
	# Should prevent random failures on installation step.
	export TERMUX_MAKE_PROCESSES=1
}
