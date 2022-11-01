TERMUX_PKG_HOMEPAGE=https://mate-desktop.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-desktop contains the libmate-desktop library, the mate-about program as well as some desktop-wide documents."
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-desktop/releases/download/v$TERMUX_PKG_VERSION/mate-desktop-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=5f7c6b9b88886cb3393b3ffd57f9e9ec29f03a3c23ce8d4b45292de0aa4652a3
TERMUX_PKG_DEPENDS="atk, dconf, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-shmem, libcairo, libpixman, libpng, libx11, libxcb, libxext, libxrandr, libxrender, mate-desktop, pango, startup-notification, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, iso-codes"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

termux_step_pre_configure() {
	termux_setup_gir
}
