TERMUX_PKG_HOMEPAGE=https://php.net
TERMUX_PKG_DESCRIPTION="Server-side, HTML-embedded scripting language"
TERMUX_PKG_LICENSE="PHP-3.0"
TERMUX_PKG_MAINTAINER=""
TERMUX_PKG_VERSION=7.4.33
TERMUX_PKG_SRCURL=https://github.com/php/php-src/archive/php-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dfbb2111160589054768a37086bda650a0041c89878449d078684d70d6a0e411
# Build native php for phar to build (see pear-Makefile.frag.patch):
TERMUX_PKG_HOSTBUILD=true
# Build the native php without xml support as we only need phar:
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear --disable-sqlite3 --without-libxml --without-sqlite3 --without-pdo-sqlite"
TERMUX_PKG_DEPENDS="libc++, freetype, libandroid-glob, libandroid-support, libbz2, libcrypt, libcurl, libgd, libgmp, libiconv, liblzma, libsqlite, libxml2, libxslt, libzip, oniguruma, openssl-1.1, pcre2, readline, zlib, libicu, libffi, tidy"
TERMUX_PKG_CONFLICTS="php, php-mysql, php-dev"
TERMUX_PKG_RM_AFTER_INSTALL="php/php/fpm"
TERMUX_PKG_SERVICE_SCRIPT=("php-fpm" 'mkdir -p ~/.php\nif [ -f "$HOME/.php/php-fpm.conf" ]; then CONFIG="$HOME/.php/php-fpm.conf"; else CONFIG="$PREFIX/etc/php-fpm.conf"; fi\nexec php-fpm -F -y $CONFIG -c ~/.php/php.ini 2>&1')

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
	CPPFLAGS+=" -DGD_FLIP_VERTICAL=1"
	CPPFLAGS+=" -DGD_FLIP_HORINZONTAL=2"
	CPPFLAGS+=" -DGD_FLIP_BOTH=3"
	CPPFLAGS+=" -DU_DEFINE_FALSE_AND_TRUE=1"

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

	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"

	local wrapper_bin=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	local _cc=$(basename $CC)
	rm -rf $wrapper_bin
	mkdir -p $wrapper_bin
	cat <<-EOF > $wrapper_bin/$_cc
		#!$(command -v sh)
		exec $(command -v $_cc) -L$TERMUX_PREFIX/lib/openssl-1.1 \
			-Wno-unused-command-line-argument "\$@"
	EOF
	chmod 0700 $wrapper_bin/$_cc
	export PATH=$wrapper_bin:$PATH
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

termux_step_create_debscripts() {
	cat <<-EOF > ./postinst
		#!$TERMUX_PREFIX/bin/sh
		echo
		echo "********"
		echo "PHP 7.4 reaches its end of life on 28 Nov 2022 and is no longer supported afterwards."
		echo "Please consider migrating to a newer version of PHP."
		echo "********"
		echo
	EOF
}
