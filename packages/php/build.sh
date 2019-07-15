TERMUX_PKG_HOMEPAGE=https://php.net
TERMUX_PKG_DESCRIPTION="Server-side, HTML-embedded scripting language"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_VERSION=7.3.7
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://secure.php.net/distributions/php-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ba067200ba649956b3a92ec8b71a6ed8ce8a099921212443c1bcf3260a29274c
# Build native php for phar to build (see pear-Makefile.frag.patch):
TERMUX_PKG_HOSTBUILD=true
# Build the native php without xml support as we only need phar:
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear"
TERMUX_PKG_DEPENDS="libiconv, libandroid-glob, libxml2, liblzma, openssl, pcre2, libbz2, libcrypt, libcurl, libgd, readline, freetype, libandroid-support, zlib"
# mysql modules were initially shared libs
TERMUX_PKG_CONFLICTS="php-mysql"
TERMUX_PKG_REPLACES="php-mysql"
TERMUX_PKG_RM_AFTER_INSTALL="php/php/fpm"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_res_nsearch=no
--enable-bcmath
--enable-calendar
--enable-exif
--enable-gd-native-ttf=$TERMUX_PREFIX
--enable-mbstring
--enable-opcache
--enable-pcntl
--enable-sockets
--enable-zip
--mandir=$TERMUX_PREFIX/share/man
--with-bz2=$TERMUX_PREFIX
--with-curl=$TERMUX_PREFIX
--with-freetype-dir=$TERMUX_PREFIX
--with-gd=$TERMUX_PREFIX
--with-libxml-dir=$TERMUX_PREFIX
--with-openssl=$TERMUX_PREFIX
--with-pcre-regex=$TERMUX_PREFIX
--with-png-dir=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
--with-zlib
--without-libzip
--with-pgsql=shared,$TERMUX_PREFIX
--with-pdo-pgsql=shared,$TERMUX_PREFIX
--with-mysqli=mysqlnd
--with-pdo-mysql=mysqlnd
--with-mysql-sock=$TERMUX_PREFIX/tmp/mysqld.sock
--with-apxs2=$TERMUX_PKG_TMPDIR/apxs-wrapper.sh
--with-iconv=$TERMUX_PREFIX
--enable-fpm
--sbindir=$TERMUX_PREFIX/bin
"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -llog"

	export PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/
	export NATIVE_PHP_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/php

	# Run autoconf since we have patched config.m4 files.
	autoconf

	export EXTENSION_DIR=$TERMUX_PREFIX/lib/php

	# Use a wrapper since bin/apxs has the Termux shebang:
	echo "perl $TERMUX_PREFIX/bin/apxs \$@" > $TERMUX_PKG_TMPDIR/apxs-wrapper.sh
	chmod +x $TERMUX_PKG_TMPDIR/apxs-wrapper.sh
	cat $TERMUX_PKG_TMPDIR/apxs-wrapper.sh
}

termux_step_post_configure() {
	# Avoid src/ext/gd/gd.c trying to include <X11/xpm.h>:
	sed -i 's/#define HAVE_GD_XPM 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
	# Avoid src/ext/standard/dns.c trying to use struct __res_state:
	sed -i 's/#define HAVE_RES_NSEARCH 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/php-fpm.d
	cp sapi/fpm/php-fpm.conf $TERMUX_PREFIX/etc/
	cp sapi/fpm/www.conf $TERMUX_PREFIX/etc/php-fpm.d/

	sed -i 's/SED=.*/SED=sed/' $TERMUX_PREFIX/bin/phpize
}
