TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
TERMUX_PKG_DESCRIPTION="A modern, docklike, minimalist taskbar for XFCE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/${_MAJOR_VERSION}/xfce4-docklike-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9da6eb18b4e755ee6affe5d36aa8af1892e5de811b0403d75a70480fe08d1b13
# exo is for bin/exo-desktop-item-edit.
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libc++, libcairo, libwnck, libx11, libxfce4ui, libxfce4util, libxi, pango, xfce4-panel, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure () {
	LDFLAGS+=" -lXi"
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
