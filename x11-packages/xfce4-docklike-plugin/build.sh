TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
TERMUX_PKG_DESCRIPTION="A modern, docklike, minimalist taskbar for XFCE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.4
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/${_MAJOR_VERSION}/xfce4-docklike-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b4136a70897895f0599e8e7237223dde17221f099a2fc816917d5894bbd4f372
# exo is for bin/exo-desktop-item-edit.
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, harfbuzz, libc++, libcairo, libwnck, libx11, libxfce4ui, libxfce4util, pango, xfce4-panel"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure () {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
