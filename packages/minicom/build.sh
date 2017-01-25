TERMUX_PKG_HOMEPAGE=https://alioth.debian.org/
TERMUX_PKG_DESCRIPTION="minicom"
TERMUX_PKG_VERSION=2.7
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://alioth.debian.org/frs/download.php/file/3977/minicom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-socket --disable-music"
