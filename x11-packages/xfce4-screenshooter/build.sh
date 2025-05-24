TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-screenshooter/start
TERMUX_PKG_DESCRIPTION="The Xfce4-screenshooter is an application that can be used to take snapshots of your desktop screen."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.11.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screenshooter/${TERMUX_PKG_VERSION%.*}/xfce4-screenshooter-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=6ae5bc4823d43e770b3a11700d048d56bdcaafdef37de7deacb8970b55fc1565
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libx11, libxext, libxfce4ui, libxfce4util, libxfixes, libwayland, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwayland=enabled
-Dx11=enabled
-Dxfixes=enabled
"

termux_step_pre_configure() {
	termux_setup_wayland_cross_pkg_config_wrapper
}
