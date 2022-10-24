TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/goffice/
TERMUX_PKG_DESCRIPTION="A GLib/GTK+ set of document-centric objects and utilities"
TERMUX_PKG_LICENSE="GPL-2.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.10
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.52
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/goffice/${_MAJOR_VERSION}/goffice-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=60b9efd94370f0969b394f0aac8c6eb91e15ebc0ce1236b44aa735eb1c98840c
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libgsf, librsvg, libspectre, libxml2, libxslt, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=no
--with-lasem=no
--without-long-double
"

termux_step_pre_configure() {
	CPPFLAGS+=" -D__USE_GNU"
}
