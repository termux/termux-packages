TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-cpugraph-plugin/start
TERMUX_PKG_DESCRIPTION="Graphical representation of the CPU load"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@knyipab"
TERMUX_PKG_VERSION="1.2.11"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-cpugraph-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-cpugraph-plugin-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=58aa31df1934afc2a352744754a730a3d796b1246e12c7a5e86f7b6a403ca20d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libandroid-glob, libc++, libcairo, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
"

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name -landroid-glob"
}
