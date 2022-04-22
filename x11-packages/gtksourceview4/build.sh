TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/GtkSourceView
TERMUX_PKG_DESCRIPTION="A GNOME library that extends GtkTextView"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.3
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gtksourceview/${_MAJOR_VERSION}/gtksourceview-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c30019506320ca2474d834cced1e2217ea533e00eb2a3f4eb7879007940ec682
TERMUX_PKG_DEPENDS="atk, fribidi, glib, gtk3, libcairo, libxml2, pango"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgir=false
-Dvapi=false
"

termux_step_pre_configure() {
	case "$TERMUX_PKG_VERSION" in
		4.*|*:4.* ) ;;
		* ) termux_error_exit "Invalid version '$TERMUX_PKG_VERSION' for package '$TERMUX_PKG_NAME'." ;;
	esac
}
