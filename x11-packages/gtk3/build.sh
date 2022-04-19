TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.24.33
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://gitlab.gnome.org/GNOME/gtk/-/archive/$TERMUX_PKG_VERSION/gtk-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c43a6082093be3e0d771f595df5669d594ae1c9c6dedbfc429fada0da80431d5
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, coreutils, desktop-file-utils, fontconfig, freetype, fribidi, gdk-pixbuf, glib, glib-bin, gtk-update-icon-cache, harfbuzz, libcairo, libepoxy, libxcomposite, libxcursor, libxdamage, libxfixes, libxi, libxinerama, libxrandr, pango, shared-mime-info, ttf-dejavu"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_CONFLICTS="libgtk3"
TERMUX_PKG_REPLACES="libgtk3"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-introspection
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

	# prevent build failure by using host's glib-compile-resources.
	cp -f /usr/bin/glib-compile-resources "${TERMUX_PREFIX}/bin/glib-compile-resources"

	NOCONFIGURE=1 ./autogen.sh
}

termux_step_post_massage() {
	# don't store updated glib-compile-resources.
	rm -f "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/bin/glib-compile-resources"
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
