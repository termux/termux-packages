TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/notifyd/start
TERMUX_PKG_DESCRIPTION="simple, visually-appealing notification daemon for Xfce"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="0.9.7"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-notifyd/${TERMUX_PKG_VERSION%.*}/xfce4-notifyd-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=170d18fd5f40cce823ffc7ae3d7e21644007c3f45808ab4835f0401d21b3516a
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk-layer-shell, gtk3, harfbuzz, libcairo, libnotify, libsqlite, libx11, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export GLIB_MKENUMS=$(command -v glib-mkenums)
	export GLIB_GENMARSHAL=$(command -v glib-genmarshal)
	export GLIB_COMPILE_RESOURCES=$(command -v glib-compile-resources)
	export GDBUS_CODEGEN=$(command -v gdbus-codegen)
}
