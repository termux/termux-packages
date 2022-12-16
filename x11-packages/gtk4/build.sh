TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtk/${_MAJOR_VERSION}/gtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=85b7a160b6e02eafa4e7d38f046f8720fab537d3fe73c01c864333a983a692a9
TERMUX_PKG_DEPENDS="adwaita-icon-theme, fontconfig, fribidi, gdk-pixbuf, glib, glib-bin, graphene, gtk-update-icon-cache, harfbuzz, libcairo, libepoxy, libjpeg-turbo, libpng, libtiff, libx11, libxcursor, libxdamage, libxext, libxfixes, libxi, libxinerama, libxrandr, pango, shared-mime-info"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, librsvg, ttf-dejavu"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Dwayland-backend=false
-Ddemos=false
-Dbuild-examples=false
-Dbuild-tests=false
-Dvulkan=disabled
-Dprint-cups=disabled
-Dmedia-gstreamer=disabled
"

termux_step_pre_configure() {
	termux_setup_gir
}
