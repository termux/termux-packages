TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.24.35
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gtk/-/archive/$TERMUX_PKG_VERSION/gtk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8b08020b183729fbc14c959c46124de10e43563334f4811a283ded0e8ba5463e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, coreutils, desktop-file-utils, fontconfig, freetype, fribidi, gdk-pixbuf, glib, glib-bin, gtk-update-icon-cache, harfbuzz, libcairo, libepoxy, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxinerama, libxrandr, pango, shared-mime-info, ttf-dejavu"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
TERMUX_PKG_CONFLICTS="libgtk3"
TERMUX_PKG_REPLACES="libgtk3"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection
--disable-cups
--enable-xinerama
--enable-xfixes
--enable-xcomposite
--enable-xdamage
--enable-x11-backend
--disable-wayland-backend
"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

termux_step_pre_configure() {
	# prevent permission denied on build scripts
	find . -type f | xargs chmod u+x

	NOCONFIGURE=1 ./autogen.sh

	termux_setup_gir

	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}

termux_step_post_configure() {
	touch ./gtk/g-ir-scanner
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
