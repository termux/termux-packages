TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
TERMUX_PKG_DESCRIPTION="A modern, docklike, minimalist taskbar for XFCE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.4.3"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-docklike-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e81e16b4ab1c655a3202473d78cc81617bb4829e5dd102eecabf9addd7668a9d
# exo is for bin/exo-desktop-item-edit.
TERMUX_PKG_DEPENDS="atk, exo, gdk-pixbuf, glib, gtk3, gtk-layer-shell, harfbuzz, libc++, libcairo, libdisplay-info, libwayland, libwnck, libx11, libxfce4ui, libxfce4util, libxfce4windowing, libxrandr, pango, xfce4-panel, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-wayland
--enable-x11
"

termux_step_pre_configure() {
	# ERROR: ./lib/xfce4/panel/plugins/libdocklike.so contains undefined symbols
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"
}
