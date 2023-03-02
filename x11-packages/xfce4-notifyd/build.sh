TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/notifyd/start
TERMUX_PKG_DESCRIPTION="simple, visually-appealing notification daemon for Xfce"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
_MAJOR_VERSION=0.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-notifyd/${_MAJOR_VERSION}/xfce4-notifyd-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e3a28adb08daa1411135142a0d421e4d6050c4035a4e513a673a59460ff2ae84
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libnotify, libsqlite, libx11, libxfce4ui, libxfce4util, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	export GLIB_GENMARSHAL=$(command -v glib-genmarshal)
	export GLIB_COMPILE_RESOURCES=$(command -v glib-compile-resources)
	export GDBUS_CODEGEN=$(command -v gdbus-codegen)
}
