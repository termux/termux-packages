TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Evince
TERMUX_PKG_DESCRIPTION="document viewer for multiple document formats"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=43
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/evince/${_MAJOR_VERSION}/evince-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=66be0de4b47b1130486103988cc152c04aea95950ba3ef16dc20c2ef6b681d47
TERMUX_PKG_DEPENDS="gdk-pixbuf, gtk3, libhandy, libarchive, djvulibre, texlive-bin, libspectre, poppler, poppler-data, libxml2, libtiff, libgxps, libsecret, gstreamer, gst-plugins-good"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dnautilus=false
-Dintrospection=false
-Dgtk_doc=false
-Dps=enabled
"
