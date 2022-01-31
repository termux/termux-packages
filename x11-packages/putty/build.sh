TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.76
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=547cd97a8daa87ef71037fab0773bceb54a8abccb2f825a49ef8eba5e045713f
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libandroid-glob, libandroid-shmem, libcairo, libx11, pango"

termux_step_pre_configure() {
	export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
	export LIBS="-landroid-glob -landroid-shmem"
}
