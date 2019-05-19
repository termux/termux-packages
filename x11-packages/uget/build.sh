TERMUX_PKG_HOMEPAGE=https://ugetdm.com/
TERMUX_PKG_DESCRIPTION="GTK+ download manager featuring download classification and HTML import"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=2.2.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/urlget/uget-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=445cf58799a9a06e08cd4180b172f4b0a8a8c2ee82da732bdfe2dd502d949936
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gstreamer, gtk3, libandroid-shmem, libcairo-x, libcurl, libnotify, openssl, pango-x"
TERMUX_PKG_SUGGESTS="aria2"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}

termux_step_post_make_install() {
	ln -sfr "${TERMUX_PREFIX}/bin/uget-gtk" "${TERMUX_PREFIX}/bin/uget"
}
