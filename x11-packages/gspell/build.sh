TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gspell
TERMUX_PKG_DESCRIPTION="Spell-checking for GTK applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=1.12
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gspell/${_MAJOR_VERSION}/gspell-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8ec44f32052e896fcdd4926eb814a326e39a5047e251eec7b9056fbd9444b0f1
TERMUX_PKG_DEPENDS="atk, enchant, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libicu, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=yes
"

termux_step_pre_configure() {
	termux_setup_gir

	export GLIB_MKENUMS=glib-mkenums
	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}
