TERMUX_PKG_HOMEPAGE=http://atterer.org/jigdo/
TERMUX_PKG_DESCRIPTION="Distribute large images by sending and receiving the files that make them up"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.2"
TERMUX_PKG_SRCURL=https://www.einval.com/~steve/software/jigdo/download/jigdo-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=36f286d93fa6b6bf7885f4899c997894d21da3a62176592ac162d9c6a8644f9e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libbz2, libc++, libdb, wget, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
--without-gui
"

termux_step_pre_configure() {
	# Should prevent random failures on installation step.
	export TERMUX_PKG_MAKE_PROCESSES=1
}
