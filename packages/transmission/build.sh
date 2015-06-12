TERMUX_PKG_HOMEPAGE=http://www.transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_DEPENDS="curl, libevent, openssl"
TERMUX_PKG_VERSION=2.84
TERMUX_PKG_SRCURL=https://transmission.cachefly.net/transmission-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --enable-lightweight --cache-file=termux_configure.cache"

# liblog for android logging in syslog hack
export LDFLAGS="$LDFLAGS -llog"

termux_step_pre_configure () {
        cd $TERMUX_PKG_SRCDIR
	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache		# prevent configure from changing
}
