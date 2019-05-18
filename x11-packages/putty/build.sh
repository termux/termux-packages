TERMUX_PKG_HOMEPAGE=https://www.chiark.greenend.org.uk/~sgtatham/putty/
TERMUX_PKG_DESCRIPTION="A terminal integrated SSH/Telnet client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.71
TERMUX_PKG_SRCURL=https://the.earth.li/~sgtatham/putty/${TERMUX_PKG_VERSION}/putty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f931ce2f89780cc8ca7bbed90fcd22c44515d2773f5fa954069e209b48ec6b8
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libandroid-glob, libandroid-shmem, libcairo-x, libx11, pango-x"

termux_step_pre_configure() {
	export CFLAGS="${CFLAGS} -Wno-deprecated-declarations"
	export LIBS="-landroid-glob -landroid-shmem"
}
