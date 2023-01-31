TERMUX_PKG_HOMEPAGE=https://www.gtk.org/
TERMUX_PKG_DESCRIPTION="GObject-based multi-platform GUI toolkit (legacy)"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=2.24
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.33
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtk+/${_MAJOR_VERSION}/gtk+-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ac2ac757f5942d318a311a54b0c80b5ef295f299c2a73c632f6bfb1ff49cc6da
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="adwaita-icon-theme, atk, coreutils, desktop-file-utils, fontconfig, freetype, glib, glib-bin, gtk-update-icon-cache, harfbuzz, libandroid-shmem, libcairo, librsvg, libx11, libxcomposite, libxcursor, libxdamage, libxext, libxfixes, libxinerama, libxrandr, libxrender, pango, shared-mime-info, ttf-dejavu"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_CONFLICTS="libgtk2"
TERMUX_PKG_REPLACES="libgtk2"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-shm
--enable-xkb
--enable-xinerama
--disable-glibtest
--disable-cups
--disable-papi
--enable-introspection=yes
"

## 1. gtk-update-icon-cache is subpackage of 'gtk3'
## 2. locales are not supported by Termux and wasting space
## 3. for backward compatibility; not in build using Git source
TERMUX_PKG_RM_AFTER_INSTALL="
bin/gtk-update-icon-cache
lib/locale
share/gtk-doc
"

termux_step_pre_configure() {
	autoreconf -fi

	termux_setup_gir

	export LIBS="-landroid-shmem"
	export LDFLAGS="${LDFLAGS} -landroid-shmem"
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
