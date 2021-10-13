TERMUX_PKG_HOMEPAGE=https://php.net
TERMUX_PKG_DESCRIPTION="Server-side, HTML-embedded scripting language"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.0.6
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/php/php-src/archive/php-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ddf7a059cf5cd26d00bc5493f1ca2242172408c0dcc4acdba6ef8952f8bb5a38
# Build native php for phar to build (see pear-Makefile.frag.patch):
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"
# Build the native php without xml support as we only need phar:
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear --disable-sqlite3 --without-libxml --without-sqlite3 --without-pdo-sqlite"
TERMUX_PKG_DEPENDS="freetype, libandroid-glob, libandroid-support, libbz2, libcrypt, libcurl, libgd, libgmp, libiconv, liblzma, libsqlite, libxml2, libxslt, libzip, oniguruma, openssl, pcre2, readline, zlib, libicu, libffi, tidy"
TERMUX_PKG_CONFLICTS="php-mysql, php-dev"
TERMUX_PKG_REPLACES="php-mysql, php-dev"
TERMUX_PKG_RM_AFTER_INSTALL="php/php/fpm"
TERMUX_PKG_SERVICE_SCRIPT=("php-fpm" "mkdir -p $TERMUX_ANDROID_HOME/.php\nif [ -f \"$TERMUX_ANDROID_HOME/.php/php-fpm.conf\" ]; then CONFIG=\"$TERMUX_ANDROID_HOME/.php/php-fpm.conf\"; else CONFIG=\"$TERMUX_PREFIX/etc/php-fpm.conf\"; fi\nexec php-fpm -F -y \$CONFIG -c ~/.php/php.ini 2>&1")

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_res_nsearch=no
--enable-bcmath
--enable-calendar
--enable-exif
--enable-mbstring
--enable-opcache
--enable-pcntl
--enable-sockets
--mandir=$TERMUX_PREFIX/share/man
--with-bz2=$TERMUX_PREFIX
--with-curl=$TERMUX_PREFIX
--with-openssl=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
--with-iconv-dir=$TERMUX_PREFIX
--with-zlib
--with-pgsql=shared,$TERMUX_PREFIX
--with-pdo-pgsql=shared,$TERMUX_PREFIX
--with-mysqli=mysqlnd
--with-pdo-mysql=mysqlnd
--with-mysql-sock=$TERMUX_PREFIX/tmp/mysqld.sock
--with-apxs2=$TERMUX_PKG_TMPDIR/apxs-wrapper.sh
--with-iconv=$TERMUX_PREFIX
--enable-fpm
--enable-gd
--with-external-gd
--with-external-pcre
--with-zip
--with-xsl
--with-gmp
--with-ffi
--with-tidy=$TERMUX_PREFIX
--enable-intl
--sbindir=$TERMUX_PREFIX/bin
"

termux_step_host_build() {
	(cd "$TERMUX_PKG_SRCDIR" && ./buildconf --force)
	"$TERMUX_PKG_SRCDIR/configure" ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -j "$TERMUX_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob -llog"

	export PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/
	export NATIVE_PHP_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/php
	if [ "$TERMUX_ARCH" = "aarch64" ]; then
		CFLAGS+=" -march=armv8-a+crc"
		CXXFLAGS+=" -march=armv8-a+crc"
	fi
	# Regenerate configure again since we have patched config.m4 files.
	./buildconf --force

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
