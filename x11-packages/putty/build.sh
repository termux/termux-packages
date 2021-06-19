TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.74
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ddd5d388e51dd9e6e294005b30037f6ae802239a44c9dc9808c779e6d11b847d
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libandroid-glob, libandroid-shmem, libcairo, libx11, pango"

termux_step_pre_configure() {
	export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
	export LIBS="-landroid-glob -landroid-shmem"
}
