TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/screenshooter/start
TERMUX_PKG_DESCRIPTION="The Xfce4-screenshooter is an application that can be used to take snapshots of your desktop screen."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=1.9.11
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screenshooter/1.9/xfce4-screenshooter-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e73d06be594b32f57d56b31482214cd7572c54adc0963f6b66c224c205f3f8b4
TERMUX_PKG_DEPENDS="atk, exo, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-shmem, libcairo, libice, libpixman, libpng, libsm, libsoup, libx11, libxcb, libxext, libxfce4ui, libxfce4util, libxfixes, libxml2, libxrender, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_prog_HELP2MAN=
"
