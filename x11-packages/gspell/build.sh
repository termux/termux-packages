TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gspell
TERMUX_PKG_DESCRIPTION="Spell-checking for GTK applications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.2"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gspell/${TERMUX_PKG_VERSION%.*}/gspell-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b4e993bd827e4ceb6a770b1b5e8950fce3be9c8b2b0cbeb22fdf992808dd2139
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, enchant, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libicu, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=yes
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

	export GLIB_MKENUMS=glib-mkenums
	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}
