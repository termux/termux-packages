TERMUX_PKG_HOMEPAGE=https://alioth.debian.org/projects/minicom/
TERMUX_PKG_DESCRIPTION="Friendly menu driven serial communication program"
TERMUX_PKG_VERSION=2.7.1
TERMUX_PKG_SHA256=890875220458e1dd4c27ecb8cec508b06365159bfe7adb8f408a07b0a48763e9
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/minicom-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-socket --disable-music"
