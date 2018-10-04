TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://www.geany.org/
TERMUX_PKG_DESCRIPTION="Fast and lightweight IDE"
TERMUX_PKG_VERSION=1.33.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://download.geany.org/geany-${TERMUX_PKG_VERSION/.0}.tar.bz2
TERMUX_PKG_SHA256=66baaff43f12caebcf0efec9a5533044dc52837f799c73a1fd7312caa86099c2
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, fribidi, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libandroid-shmem, libandroid-support, libbz2, libc++, libcairo-x, libffi, libgraphite, liblzma, libpixman, libpng, libuuid, libx11, libxau, libxcb, libxdmcp, libxext, libxml2, libxrender, pango-x, pcre"
TERMUX_PKG_RECOMMENDS="clang, make"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"
TERMUX_PKG_RM_AFTER_INSTALL="share/icons/hicolor/icon-theme.cache"

termux_step_pre_configure() {
    export LIBS="-landroid-glob"
}
