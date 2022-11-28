TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Clutter
TERMUX_PKG_DESCRIPTION="A library providing facilities to integrate Clutter into GTK+ applications and vice versa"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/clutter-gtk/${_MAJOR_VERSION}/clutter-gtk-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=521493ec038973c77edcb8bc5eac23eed41645117894aaee7300b2487cb42b06
TERMUX_PKG_DEPENDS="atk, clutter, cogl, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, json-glib, libcairo, libx11, libxcomposite, libxdamage, libxext, libxfixes, libxi, libxrandr, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
