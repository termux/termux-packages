TERMUX_PKG_HOMEPAGE=http://www.transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_DEPENDS="libevent, openssl, libcurl"
TERMUX_PKG_VERSION=2.93
TERMUX_PKG_SRCURL=https://github.com/transmission/transmission/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=870ea21a2803c141126bb3f2da4e9acab8db7c0b403a64f685f410b629497a8a
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --enable-lightweight --cache-file=termux_configure.cache"

termux_step_pre_configure() {
	./autogen.sh
	# liblog for android logging in syslog hack:
	LDFLAGS+=" -llog"

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}
