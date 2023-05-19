TERMUX_PKG_HOMEPAGE=https://www.lighttpd.net
TERMUX_PKG_DESCRIPTION="Fast webserver with minimal memory footprint"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.70
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=921ebe1cf4b6b9897e03779ab7a23a31f4ba40a1abe2067525c33cd3ce61fe85
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-bzip2 --with-openssl --with-zlib"
TERMUX_PKG_DEPENDS="libandroid-glob, libbz2, libcrypt, openssl, pcre2, zlib"
TERMUX_PKG_RM_AFTER_INSTALL="bin/lighttpd-angel"
TERMUX_PKG_SERVICE_SCRIPT=("lighttpd" "if [ -f \"$TERMUX_ANDROID_HOME/.lighttpd/lighttpd.conf\" ]; then CONFIG=\"$TERMUX_ANDROID_HOME/.lighttpd/lighttpd.conf\"; else CONFIG=\"$TERMUX_PREFIX/etc/lighttpd/lighttpd.conf\"; fi\nexec lighttpd -D -f \$CONFIG 2>&1")

termux_step_pre_configure() {
	LDFLAGS="$LDFLAGS -landroid-glob"
}

termux_step_post_make_install() {
	# Install example config file
	install -Dm600 -t $TERMUX_PREFIX/etc/lighttpd/ \
		$TERMUX_PKG_SRCDIR/doc/config/lighttpd.conf \
		$TERMUX_PKG_SRCDIR/doc/config/modules.conf
	install -Dm600 -t $TERMUX_PREFIX/etc/lighttpd/conf.d \
		$TERMUX_PKG_SRCDIR/doc/config/conf.d/*.conf
	install -Dm600 -t $TERMUX_PREFIX/etc/lighttpd/vhosts.d \
		$TERMUX_PKG_SRCDIR/doc/config/vhosts.d/vhosts.template
}
