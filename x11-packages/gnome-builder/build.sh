TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/Builder/
TERMUX_PKG_DESCRIPTION="An IDE for writing GNOME-based software"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="49.1"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-builder/${TERMUX_PKG_VERSION%.*}/gnome-builder-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3b9e4798388f959e1032c6ace4a5fb7b4e588b6339fce4c22ec26abe869f8a2b
TERMUX_PKG_DEPENDS="cmark, editorconfig-core-c, jsonrpc-glib, glib, gobject-introspection, gtk4, gtksourceview5, libadwaita, libandroid-wordexp, libdex, libpanel, libpeas2, libportal-gtk4, libspelling, libvte, libxml2, libyaml, template-glib, webkitgtk-6.0"
TERMUX_PKG_BUILD_DEPENDS="cmark-static, ctags, desktop-file-utils, g-ir-scanner, glib-cross, gettext, libandroid-wordexp-static"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
# To enable plugin, please patch its path
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwith_safe_path=$TERMUX_PREFIX/bin
-Dplugin_flatpak=false
-Dplugin_manuals=false
-Dplugin_clang=false
-Dplugin_clangd=false
-Dplugin_clang_format=false
-Dplugin_git=false
-Dplugin_sysprof=false
-Dplugin_podman=false
-Dplugin_qemu=false
-Dnetwork_tests=false
-Dtracing=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	LDFLAGS+=" -landroid-wordexp"
}
