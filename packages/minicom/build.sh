TERMUX_PKG_HOMEPAGE=https://alioth.debian.org/projects/minicom/
TERMUX_PKG_DESCRIPTION="Friendly menu driven serial communication program"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://alioth.debian.org/frs/download.php/file/3977/minicom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9ac3a663b82f4f5df64114b4792b9926b536c85f59de0f2d2b321c7626a904f4
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-socket --disable-music"
