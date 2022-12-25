TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.24.36
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gtk/-/archive/$TERMUX_PKG_VERSION/gtk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8c5c6f56da1a6700662853279ef68602fd24733677cd1bcf346b88318c88a991
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, coreutils, desktop-file-utils, fontconfig, fribidi, gdk-pixbuf, glib, glib-bin, gtk-update-icon-cache, harfbuzz, libcairo, libepoxy, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxinerama, libxrandr, pango, shared-mime-info, ttf-dejavu"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xorgproto"
TERMUX_PKG_CONFLICTS="libgtk3"
TERMUX_PKG_REPLACES="libgtk3"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dx11_backend=true
-Dwayland_backend=false
-Dbroadway_backend=true
-Dxinerama=yes
-Dprint_backends=file,lpr
-Dman=true
-Dintrospection=true
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
