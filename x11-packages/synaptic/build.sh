TERMUX_PKG_HOMEPAGE=https://www.nongnu.org/synaptic/
TERMUX_PKG_DESCRIPTION="Synaptic is a graphical package management tool based on GTK+ and APT."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="0.92"
TERMUX_PKG_SRCURL=https://github.com/mvo5/synaptic/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=4c4d338a487541e13c37f6c340b49ef317f6cccb6bb3a95cf47a1d0dd222e99d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="apt, dpkg, gdk-pixbuf, glib, gtk3, libc++, libvte, libx11, pango"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme, netsurf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dtests=disabled"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
