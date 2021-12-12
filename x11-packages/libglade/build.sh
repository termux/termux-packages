TERMUX_PKG_HOMEPAGE=https://www.gnome.org/
TERMUX_PKG_DESCRIPTION="Allows you to load glade interface files in a program at runtime"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.4
TERMUX_PKG_REVISION=22
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libglade/2.6/libglade-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=64361e7647839d36ed8336d992fd210d3e8139882269bed47dc4674980165dec
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk2, libcairo, libxml2, pango"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc"

# For libglade-convert.
TERMUX_PKG_SUGGESTS="python2"

termux_step_pre_configure() {
	export LIBS="-lgmodule-2.0"
}

termux_step_post_make_install() {
	sed \
		-i "s|#!/usr/bin/python|#!${TERMUX_PREFIX}/bin/python2|g" \
		"${TERMUX_PREFIX}/bin/libglade-convert"
}
