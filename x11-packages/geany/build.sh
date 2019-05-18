TERMUX_PKG_HOMEPAGE=https://www.geany.org/
TERMUX_PKG_DESCRIPTION="Fast and lightweight IDE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.35.0
TERMUX_PKG_SRCURL=https://download.geany.org/geany-${TERMUX_PKG_VERSION/.0}.tar.bz2
TERMUX_PKG_SHA256=35ee1d3ddfadca8bf1764e174ba3a5f348b1f1f430d32a36295b7706b7753d9d
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, fribidi, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libandroid-shmem, libbz2, libc++, libcairo-x, libffi, libgraphite, liblzma, libpixman, libpng, libuuid, libx11, libxau, libxcb, libxdmcp, libxext, libxml2, libxrender, pango-x, pcre, zlib"
TERMUX_PKG_RECOMMENDS="clang, make"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-gtk3"

TERMUX_PKG_RM_AFTER_INSTALL="
share/icons/hicolor/icon-theme.cache
share/icons/Tango/icon-theme.cache
"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
