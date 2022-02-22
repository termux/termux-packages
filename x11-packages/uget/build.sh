TERMUX_PKG_HOMEPAGE=https://ugetdm.com/
TERMUX_PKG_DESCRIPTION="GTK+ download manager featuring download classification and HTML import"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.2.3
TERMUX_PKG_REVISION=20
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/urlget/uget-${TERMUX_PKG_VERSION}-1.tar.gz
TERMUX_PKG_SHA256=11356e4242151b9014fa6209c1f0360b699b72ef8ab47dbeb81cc23be7db9049
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gstreamer, gtk3, libandroid-shmem, libcairo, libcurl, libnotify, openssl, pango"
TERMUX_PKG_SUGGESTS="aria2"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
	export LIBS="-landroid-shmem"
}

termux_step_post_make_install() {
	ln -sfr "${TERMUX_PREFIX}/bin/uget-gtk" "${TERMUX_PREFIX}/bin/uget"
}
