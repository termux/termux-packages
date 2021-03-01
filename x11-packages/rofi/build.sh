TERMUX_PKG_HOMEPAGE=https://github.com/DaveDavenport/rofi
TERMUX_PKG_DESCRIPTION="A window switcher, application launcher and dmenu replacement"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL="https://github.com/DaveDavenport/rofi/releases/download/$TERMUX_PKG_VERSION/rofi-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=424c6ea7b14b3dac324ab065e59c5f3fb877befb46914a0498e8bd4017fae98a
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-shmem, libcairo, librsvg, libxkbcommon, startup-notification, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-check"

termux_step_pre_configure() {
	export LIBS="-landroid-glob -landroid-shmem"
	export GLIB_GENMARSHAL=glib-genmarshal
	export GOBJECT_QUERY=gobject-query
	export GLIB_MKENUMS=glib-mkenums
	export GLIB_COMPILE_RESOURCES=glib-compile-resources
}
