TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/gnome-font-viewer
TERMUX_PKG_DESCRIPTION="A font viewer utility for GNOME"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="47.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/gnome-font-viewer/${TERMUX_PKG_VERSION%.*}/gnome-font-viewer-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b8e5a042e0b241b0c7cae43f74da0d5f88e6423017a91feb86e7617edb4080ed
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="fontconfig, freetype, fribidi, glib, graphene, gtk4, harfbuzz, libadwaita, libcairo, pango"
TERMUX_PKG_BUILD_DEPENDS="glib-cross"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
