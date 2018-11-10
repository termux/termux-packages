TERMUX_PKG_HOMEPAGE=http://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_VERSION=1.4.51
TERMUX_PKG_SHA256=2af9fdb265d1f025bfa634e13770239712ecbd585e4975b8226edf1df74e9c82
TERMUX_PKG_SRCURL=http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"

termux_step_pre_configure () {
	# liblog for syslog:
	LDFLAGS="$LDFLAGS -llog -landroid-glob"
}
