TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GdkPixbuf
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.42
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.10
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/${_MAJOR_VERSION}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo, zstd"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="gdk-pixbuf-dev"
TERMUX_PKG_REPLACES="gdk-pixbuf-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
-Dintrospection=enabled
-Dgio_sniffing=false
"

termux_step_pre_configure() {
	termux_setup_gir
}

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
