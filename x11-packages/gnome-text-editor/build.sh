TERMUX_PKG_HOMEPAGE=https://apps.gnome.org/TextEditor/
TERMUX_PKG_DESCRIPTION="GNOME Text Editor is a simple text editor focused on a pleasing default experience"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="50.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-text-editor/${TERMUX_PKG_VERSION%.*}/gnome-text-editor-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=9dc299da4daa085423b5d48db59f0021ad55e74143a5cb8ab2e5ffe17967f45b
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="editorconfig-core-c, glib, gtk4, gtksourceview5, libadwaita, libandroid-wordexp, libcairo, libspelling, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross, valac"
TERMUX_PKG_RECOMMENDS="gnome-text-editor-help"

termux_step_pre_configure() {
	# Workaround strict compiler error
	sed -i "s/-Werror/-Wno-error/g" meson.build

	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export LDFLAGS+=" -landroid-wordexp"
}
