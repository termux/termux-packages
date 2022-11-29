TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Clutter
TERMUX_PKG_DESCRIPTION="An open source software library for creating fast, compelling, portable, and dynamic graphical user interfaces"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.26
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.4
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/clutter/${_MAJOR_VERSION}/clutter-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8b48fac159843f556d0a6be3dbfc6b083fc6d9c58a20a49a6b4919ab4263c4e6
TERMUX_PKG_DEPENDS="atk, cogl, fontconfig, freetype, gdk-pixbuf, glib, gtk3, harfbuzz, json-glib, libcairo, libx11, libxcomposite, libxdamage, libxext, libxfixes, libxi, libxrandr, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir

	export GLIB_GENMARSHAL=glib-genmarshal
	export GOBJECT_QUERY=gobject-query
	export GLIB_MKENUMS=glib-mkenums
	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}
