TERMUX_PKG_HOMEPAGE=https://transmissionbt.com/
TERMUX_PKG_DESCRIPTION="Easy, lean and powerful BitTorrent client"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_DEPENDS="libevent, openssl, libcurl"
TERMUX_PKG_VERSION=2.94
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/transmission/transmission/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=440c2fd0f89b1ab59d8a4b79ecd7bffd61bc000e36fb5b6c8e88142a4fadbb1f
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-gtk --enable-lightweight --cache-file=termux_configure.cache"

termux_step_pre_configure() {
	./autogen.sh
	# liblog for android logging in syslog hack:
	LDFLAGS+=" -llog"

	echo "ac_cv_func_getmntent=no" >> termux_configure.cache
	echo "ac_cv_search_getmntent=false" >> termux_configure.cache
	chmod a-w termux_configure.cache
}

termux_step_post_make_install() {
    	# Setup transmission service script
	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	mkdir -p transmission/log
	echo "#!$TERMUX_PREFIX/bin/sh" > transmission/run
        echo 'mkdir -p ~/torrent/torrent-files' >> transmission/run
	echo 'mkdir -p ~/torrent/download' >> transmission/run
	echo 'exec transmission-daemon \' >> transmission/run
	echo '    -f \' >> transmission/run
	echo '    -c ~/torrent/torrent-files \' >> transmission/run
	echo '    -w ~/torrent/download \' >> transmission/run
	echo '    2>&1' >> transmission/run
	chmod +x transmission/run
	touch transmission/down

	echo "#!$TERMUX_PREFIX/bin/sh" > transmission/log/run
	echo 'mkdir -p "$LOGDIR/sv/transmission"' >> transmission/log/run
	echo 'exec svlogd "$LOGDIR/sv/transmission"' >> transmission/log/run
        chmod +x transmission/log/run
}
