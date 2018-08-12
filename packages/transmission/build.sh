TERMUX_PKG_HOMEPAGE=http://www.transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_DEPENDS="libevent, openssl, libcurl"
TERMUX_PKG_VERSION=2.94
TERMUX_PKG_SRCURL=https://github.com/transmission/transmission-releases/raw/master/transmission-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=35442cc849f91f8df982c3d0d479d650c6ca19310a994eccdaa79a4af3916b7d
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --enable-lightweight --cache-file=termux_configure.cache"

termux_step_pre_configure() {
	./autogen.sh
	# liblog for android logging in syslog hack:
	LDFLAGS+=" -llog"

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
