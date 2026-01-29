TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Apps/Terminal
TERMUX_PKG_DESCRIPTION="Terminal emulator for GNOME"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.58.1"
# "https://download.gnome.org/sources/gnome-terminal/${TERMUX_PKG_VERSION%.*}/gnome-terminal-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/GNOME/gnome-terminal/-/archive/${TERMUX_PKG_VERSION}/gnome-terminal-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6165f671fb26d8b724f22a185d90212787512e375108b02a27df5069efb846c9
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libx11, dbus, gsettings-desktop-schemas, libhandy, libvte "
TERMUX_PKG_BUILD_DEPENDS="glib-cross, dconf, pcre2, gettext, libxslt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Ddbg=false
-Dnautilus_extension=false
-Dsearch_provider=false
"

termux_step_post_get_source() {
	rm -f subprojects/*.wrap
}

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}

termux_step_post_make_install() {
	install -Dm644 "$TERMUX_PKG_BUILDER_DIR/org.gnome.Terminal.gschema.override" "$TERMUX_PREFIX/share/glib-2.0/schemas/org.gnome.Terminal.gschema.override"
}
