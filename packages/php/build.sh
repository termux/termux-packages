TERMUX_PKG_HOMEPAGE=https://php.net
TERMUX_PKG_DESCRIPTION="Server-side, HTML-embedded scripting language"
TERMUX_PKG_VERSION=7.1.2
TERMUX_PKG_SRCURL=http://www.php.net/distributions/php-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d815a0c39fd57bab1434a77ff0610fb507c22f790c66cd6f26e27030c4b3e971
# Build native php for phar to build (see pear-Makefile.frag.patch):
TERMUX_PKG_HOSTBUILD=true
# Build the native php without xml support as we only need phar:
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear"
TERMUX_PKG_DEPENDS="libandroid-glob, libxml2, liblzma, openssl, pcre, libbz2, libcrypt, libcurl, libgd, libicu, readline, freetype"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_res_nsearch=no
--enable-bcmath
--enable-calendar
--enable-exif
--enable-gd-native-ttf=$TERMUX_PREFIX
--enable-intl
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
--with-iconv=$TERMUX_PREFIX
--with-libxml-dir=$TERMUX_PREFIX
--with-openssl=$TERMUX_PREFIX
--with-pcre-regex=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
--with-zlib
"

termux_step_pre_configure () {
	LDFLAGS+=" -landroid-glob -llog"

	export PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/
	export NATIVE_PHP_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/php

	# Run autoconf since we have patched config.m4 files.
	cd $TERMUX_PKG_SRCDIR
	autoconf
}

termux_step_post_configure () {
	# Avoid src/ext/gd/gd.c trying to include <X11/xpm.h>:
	perl -p -i -e 's/#define HAVE_GD_XPM 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
	# Avoid src/ext/standard/dns.c trying to use struct __res_state:
	perl -p -i -e 's/#define HAVE_RES_NSEARCH 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
	# Fix tmp path for building extensions
	perl -p -i -e "s#TMPDIR=/tmp#TMPDIR=$TERMUX_PREFIX/tmp#" $TERMUX_PKG_SRCDIR/config.guess
	perl -p -i -e "s#tmpdir=\"/tmp\"#tmpdir=\"$TERMUX_PREFIX/tmp\"#" $TERMUX_PKG_SRCDIR/build/shtool
	# Fix sed path on phpize script
	perl -p -i -e "s#SED=\"/usr/bin/sed\"#SED=\"$TERMUX_PREFIX/bin/sed\"#" $TERMUX_PKG_BUILDDIR/scripts/phpize
	# Fix sed path on php-config script
	perl -p -i -e "s#SED=\"/usr/bin/sed\"#SED=\"$TERMUX_PREFIX/bin/sed\"#" $TERMUX_PKG_BUILDDIR/scripts/php-config
}
