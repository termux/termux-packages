TERMUX_PKG_HOMEPAGE=http://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_VERSION=1.4.48
TERMUX_PKG_SHA256=0f8ad5aac7529d7b948b9d7e8cd0b4a9e177309d85d6bf6516e28e6e40d74f36
TERMUX_PKG_SRCURL=http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-pcre --with-zlib"
TERMUX_PKG_DEPENDS="libbz2, openssl, pcre, libcrypt, libandroid-glob"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"

termux_step_pre_configure () {
	# liblog for syslog:
	LDFLAGS="$LDFLAGS -llog -landroid-glob"
}
