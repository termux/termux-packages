TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.73
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3db0b5403fb41aecd3aa506611366650d927650b6eb3d839ad4dcc782519df1c
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libandroid-glob, libandroid-shmem, libcairo, libx11, pango"

termux_step_pre_configure() {
	export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
	export LIBS="-landroid-glob -landroid-shmem"
}
