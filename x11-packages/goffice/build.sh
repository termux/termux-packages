TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/goffice/
TERMUX_PKG_DESCRIPTION="A GLib/GTK+ set of document-centric objects and utilities"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.60"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/goffice/${TERMUX_PKG_VERSION%.*}/goffice-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=01154338cbffac172fc53338ebb9d527c821ffc21985a2ccfa84923ee6b761c5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libgsf, librsvg, libspectre, libxml2, libxslt, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--with-lasem=no
--without-long-double
"

termux_step_pre_configure() {
	termux_setup_gir

	CPPFLAGS+=" -D__USE_GNU"
}

termux_step_post_configure() {
	touch ./goffice/g-ir-scanner
}
