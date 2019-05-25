TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.70
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bb8aa49d6e96c5a8e18a057f3150a1695ed99a24eef699e783651d1f24e7b0be
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libandroid-glob, libandroid-shmem, libcairo-x, libx11, pango-x"

termux_step_pre_configure() {
	export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
	export LIBS="-landroid-glob -landroid-shmem"
}
