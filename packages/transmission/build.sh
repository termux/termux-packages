TERMUX_PKG_HOMEPAGE=http://www.transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_DEPENDS="libevent, openssl, libcurl"
TERMUX_PKG_VERSION=2.92
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://transmission.cachefly.net/transmission-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3a8d045c306ad9acb7bf81126939b9594553a388482efa0ec1bfb67b22acd35f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --enable-lightweight --cache-file=termux_configure.cache"

termux_step_pre_configure() {
	# liblog for android logging in syslog hack:
	LDFLAGS+=" -llog"

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
