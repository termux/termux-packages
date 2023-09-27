TERMUX_PKG_HOMEPAGE=https://github.com/DaveDavenport/rofi
TERMUX_PKG_DESCRIPTION="A window switcher, application launcher and dmenu replacement"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=1.7.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/DaveDavenport/rofi/releases/download/$TERMUX_PKG_VERSION/rofi-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=caffcf66d165cb32b748c1db7f229d6d75da58c1685eb17455f65c60e8220c8d
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, libandroid-glob, libcairo, libxcb, libxkbcommon, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-wm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-check"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
	export GLIB_GENMARSHAL=glib-genmarshal
	export GOBJECT_QUERY=gobject-query
	export GLIB_MKENUMS=glib-mkenums
	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}
