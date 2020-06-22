TERMUX_PKG_HOMEPAGE=https://github.com/DaveDavenport/rofi
TERMUX_PKG_DESCRIPTION="A window switcher, application launcher and dmenu replacement"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Tristan Ross <spaceboyross@yandex.com>"
TERMUX_PKG_VERSION=1.5.4
TERMUX_PKG_REVISION=19
TERMUX_PKG_SRCURL="https://github.com/DaveDavenport/rofi/releases/download/$TERMUX_PKG_VERSION/rofi-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=91a502cc29f964b529cd6228dbe655e82ab4e69c9852d23a24d9c1efb1af54db
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-shmem, libcairo, librsvg, libxkbcommon, startup-notification, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-check"

termux_step_pre_configure() {
	export LIBS="-landroid-glob -landroid-shmem"
}
