TERMUX_PKG_HOMEPAGE=https://gedit-technology.github.io/apps/gedit/
TERMUX_PKG_DESCRIPTION="GNOME Text Editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="48.2"
# for submodules https://gitlab.gnome.org/World/gedit/gedit/-/issues/611
TERMUX_PKG_SRCURL="git+https://gitlab.gnome.org/World/gedit/gedit"
TERMUX_PKG_SHA256=fb13faeda36b2c79dff47e5ebcb84981b7f08fbbef866123a64f63b2ead8bb33
TERMUX_PKG_GIT_BRANCH="${TERMUX_PKG_VERSION}"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gobject-introspection, gsettings-desktop-schemas, gspell, gtk3, libcairo, libgedit-amtk, libgedit-gfls, libgedit-gtksourceview, libgedit-tepl, libpeas, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_RECOMMENDS="gedit-help"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk_doc=false
"

termux_step_post_get_source() {
	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]] ; then
		termux_error_exit "Checksum mismatch for source files.\nExpected: ${TERMUX_PKG_SHA256}\nActual:   ${s%% *}"
	fi
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
