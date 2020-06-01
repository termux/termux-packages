TERMUX_PKG_HOMEPAGE=https://transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client (gtk3)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=2.94
TERMUX_PKG_REVISION=16
TERMUX_PKG_SRCURL=https://github.com/transmission/transmission/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=440c2fd0f89b1ab59d8a4b79ecd7bffd61bc000e36fb5b6c8e88142a4fadbb1f

TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, libcairo, libcurl, libevent, openssl, pango, zlib"
TERMUX_PKG_CONFLICTS="transmission"
TERMUX_PKG_REPLACES="transmission"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-nls
--enable-cli
--enable-gtk
--enable-lightweight
--cache-file=termux_configure.cache
"

TERMUX_PKG_RM_AFTER_INSTALL="share/icons/hicolor/icon-theme.cache"

termux_step_pre_configure() {
	./autogen.sh
	# liblog for android logging in syslog hack:
	LDFLAGS+=" -landroid-shmem -llog"

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
