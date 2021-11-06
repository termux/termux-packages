TERMUX_PKG_HOMEPAGE=http://atterer.org/jigdo/
TERMUX_PKG_DESCRIPTION="Distribute large images by sending and receiving the files that make them up"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.8.1
TERMUX_PKG_SRCURL=https://www.einval.com/~steve/software/jigdo/download/jigdo-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=b1f08c802dd7977d90ea809291eb0a63888b3984cc2bf4c920ecc2a1952683da
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
