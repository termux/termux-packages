TERMUX_PKG_HOMEPAGE=https://github.com/DaveDavenport/rofi
TERMUX_PKG_DESCRIPTION="A window switcher, application launcher and dmenu replacement"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL="https://github.com/DaveDavenport/rofi/releases/download/$TERMUX_PKG_VERSION/rofi-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=c487a8a010345bd596c433702e054db3728f0e8f275c325f58ee2e9a1259c614
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-shmem, libcairo, librsvg, libxkbcommon, startup-notification, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-check"

termux_step_pre_configure() {
	export LIBS="-landroid-glob -landroid-shmem"
}
