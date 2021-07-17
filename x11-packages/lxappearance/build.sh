TERMUX_PKG_HOMEPAGE=http://www.lxde.org/
TERMUX_PKG_DESCRIPTION="LXDE GTK+ theme switcher"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Yisus7u7"
TERMUX_PKG_VERSION=0.6.3
TERMUX_PKG_SRCURL=https://github.com/lxde/lxappearance/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0b74a0ed0eb6f221b027a30c4829015794fefab7b2ce714ed6194454af7c08ce
TERMUX_PKG_DEPENDS="gtk2, glib, gtk3, libx11, xsltproc"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	./autogen.sh
}

termux_step_make_install () {
	cd $TERMUX_PKG_SRCDIR/src
	make install 
}
