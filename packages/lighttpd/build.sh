TERMUX_PKG_HOMEPAGE=http://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_VERSION=1.4.50
TERMUX_PKG_SHA256=29378312d8887cbc14ffe8a7fadef2d5a08c7e7e1be942795142346ad95629eb
TERMUX_PKG_SRCURL=http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"

termux_step_pre_configure () {
	# liblog for syslog:
	LDFLAGS="$LDFLAGS -llog -landroid-glob"
}
