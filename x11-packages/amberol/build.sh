TERMUX_PKG_HOMEPAGE="https://apps.gnome.org/Amberol/"
TERMUX_PKG_DESCRIPTION="Small and simple sound and music player that is well integrated with GNOME"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2026.1"
TERMUX_PKG_SRCURL="https://gitlab.gnome.org/World/amberol/-/archive/${TERMUX_PKG_VERSION}/amberol-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="2112eebac5c7b0aab7243c428c794aecb136168c326648cfbbd8654ea2cc7631"
TERMUX_PKG_DEPENDS="dconf, gdk-pixbuf, glib, graphene, gst-plugins-bad, gst-plugins-base, gst-plugins-good, gstreamer, gtk4, hicolor-icon-theme, libadwaita, pango"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, glib-cross, libiconv"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	export CARGO_BUILD_TARGET="${CARGO_TARGET_NAME}"
	export PKG_CONFIG_ALLOW_CROSS=1

	local env_host=$(printf $CARGO_TARGET_NAME | tr a-z A-Z | sed s/-/_/g)
	export CARGO_TARGET_${env_host}_RUSTFLAGS+=" -C link-arg=-liconv"

	termux_setup_rust
	termux_setup_meson
	termux_setup_bpc
	termux_setup_glib_cross_pkg_config_wrapper
}
