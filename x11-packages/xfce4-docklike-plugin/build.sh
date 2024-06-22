TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
TERMUX_PKG_DESCRIPTION="A modern, docklike, minimalist taskbar for XFCE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-docklike-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b6a40b976a78f2abb1bec057c48d45bfb317e00b12e05a7dfcbea4d183f8db71
# exo is for bin/exo-desktop-item-edit.
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libc++, libcairo, libwnck, libx11, libxfce4ui, libxfce4util, libxi, pango, xfce4-panel, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure () {
	LDFLAGS+=" -lXi"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
