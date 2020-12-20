TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/gdk-pixbuf/
TERMUX_PKG_DESCRIPTION="Library for image loading and manipulation"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.42.2
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gdk-pixbuf/-/archive/${TERMUX_PKG_VERSION}/gdk-pixbuf-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=249b977279f761979104d7befbb5ee23f1661e29d19a36da5875f3a97952d13f
TERMUX_PKG_DEPENDS="glib, libpng, libtiff, libjpeg-turbo"
TERMUX_PKG_BREAKS="gdk-pixbuf-dev"
TERMUX_PKG_REPLACES="gdk-pixbuf-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgio_sniffing=false
-Dgir=false
-Dx11=false
"

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
