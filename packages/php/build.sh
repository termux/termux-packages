TERMUX_PKG_HOMEPAGE=https://php.net
TERMUX_PKG_DESCRIPTION="Server-side, HTML-embedded scripting language"
TERMUX_PKG_LICENSE="PHP-3.01"
TERMUX_PKG_LICENSE_FILE=LICENSE
TERMUX_PKG_MAINTAINER="@termux"
# Please revbump php-* extensions along with "minor" bump (e.g. 8.1.x to 8.2.0)
TERMUX_PKG_VERSION="8.4.2"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/php/php-src/archive/php-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5adb0def4110fcba4b84ab11d960e4dc58cab78b2d4e0a59bbef340a5c819f14
TERMUX_PKG_AUTO_UPDATE=false
# Build native php for phar to build (see pear-Makefile.frag.patch):
TERMUX_PKG_HOSTBUILD=true
# Build the native php without xml support as we only need phar:
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-libxml --disable-dom --disable-simplexml --disable-xml --disable-xmlreader --disable-xmlwriter --without-pear --disable-sqlite3 --without-libxml --without-sqlite3 --without-pdo-sqlite"
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-support, libbz2, libc++, libcurl, libffi, libgmp, libiconv, libicu, libresolv-wrapper, libsqlite, libxml2, libxslt, libzip, oniguruma, openssl, pcre2, readline, tidy, zlib"
TERMUX_PKG_BUILD_DEPENDS="postgresql"
TERMUX_PKG_CONFLICTS="php-mysql, php-dev"
TERMUX_PKG_REPLACES="php-mysql, php-dev"
TERMUX_PKG_RM_AFTER_INSTALL="php/php/fpm"
TERMUX_PKG_SERVICE_SCRIPT=("php-fpm" "mkdir -p $TERMUX_ANDROID_HOME/.php\nif [ -f \"$TERMUX_ANDROID_HOME/.php/php-fpm.conf\" ]; then CONFIG=\"$TERMUX_ANDROID_HOME/.php/php-fpm.conf\"; else CONFIG=\"$TERMUX_PREFIX/etc/php-fpm.conf\"; fi\nexec php-fpm -F -y \$CONFIG -c ~/.php/php.ini 2>&1")

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_res_nsearch=no
ac_cv_phpdbg_userfaultfd_writefault=no
php_cv_lib_gd_gdImageCreateFromPng=yes
php_cv_lib_gd_gdImageCreateFromAvif=yes
php_cv_lib_gd_gdImageCreateFromWebp=yes
php_cv_lib_gd_gdImageCreateFromJpeg=yes
php_cv_lib_gd_gdImageCreateFromBmp=yes
php_cv_lib_gd_gdImageCreateFromTga=yes
--enable-bcmath
--enable-calendar
--enable-exif
--enable-mbstring
--enable-opcache
--enable-pcntl
--enable-sockets
--mandir=$TERMUX_PREFIX/share/man
--with-bz2=$TERMUX_PREFIX
--with-config-file-path=$TERMUX_PREFIX/etc/$TERMUX_PKG_NAME
--with-config-file-scan-dir=$TERMUX_PREFIX/etc/$TERMUX_PKG_NAME/conf.d
--with-curl=$TERMUX_PREFIX
--with-ldap=shared,$TERMUX_PREFIX
--with-ldap-sasl
--with-openssl=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
--with-sodium=shared,$TERMUX_PREFIX
--with-zlib
--with-pgsql=shared,$TERMUX_PREFIX
--with-pdo-pgsql=shared,$TERMUX_PREFIX
--with-mysqli=mysqlnd
--with-pdo-mysql=mysqlnd
--with-mysql-sock=$TERMUX_PREFIX/tmp/mysqld.sock
--with-apxs2=$TERMUX_PKG_TMPDIR/apxs-wrapper.sh
--with-iconv=$TERMUX_PREFIX
--enable-fpm
--enable-gd=shared,$TERMUX_PREFIX
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
	# PatchELF packaged in Ubuntu is too old.
	local PATCHELF_BUILD_SH=$TERMUX_SCRIPTDIR/packages/patchelf/build.sh
	local PATCHELF_SRCURL=$(bash -c ". $PATCHELF_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local PATCHELF_SHA256=$(bash -c ". $PATCHELF_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local PATCHELF_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $PATCHELF_SRCURL)
	termux_download $PATCHELF_SRCURL $PATCHELF_TARFILE $PATCHELF_SHA256
	local PATCHELF_SRCDIR=$TERMUX_PKG_HOSTBUILD_DIR/_patchelf
	mkdir -p $PATCHELF_SRCDIR
	tar xf $PATCHELF_TARFILE -C $PATCHELF_SRCDIR --strip-components=1
	pushd $PATCHELF_SRCDIR
	./bootstrap.sh
	./configure
	make -j $TERMUX_PKG_MAKE_PROCESSES
	popd

	(cd "$TERMUX_PKG_SRCDIR" && ./buildconf --force)
	"$TERMUX_PKG_SRCDIR/configure" ${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_pre_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR/_patchelf/src:$PATH

	# warning: static library libclang_rt.builtins-aarch64-android.a is not portable
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname $_libgcc_file)"
	local _libgcc_name="$(basename $_libgcc_file)"
	LDFLAGS+=" -lresolv_wrapper -landroid-glob -llog -L$_libgcc_path -l:$_libgcc_name -lm"

	export PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/
	export NATIVE_PHP_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/php
	export NATIVE_MINILUA_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/ext/opcache/jit/ir/minilua
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

	# Fix overlinking (unneeded DT_NEEDED entries) with libtool:
	local wrapper_bin=$TERMUX_PKG_BUILDDIR/_wrapper/bin
	local _cc=$(basename $CC)
	rm -rf $wrapper_bin
	mkdir -p $wrapper_bin
	cat <<-EOF > $wrapper_bin/$_cc
		#!$(command -v sh)
		exec $(command -v $_cc) \
			--start-no-unused-arguments \
			-Wl,--as-needed \
			--end-no-unused-arguments \
			"\$@"
	EOF
	chmod 0700 $wrapper_bin/$_cc
	export PATH=$wrapper_bin:$PATH
}

termux_step_post_configure() {
	# Avoid src/ext/gd/gd.c trying to include <X11/xpm.h>:
	sed -i 's/#define HAVE_GD_XPM 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
	# Avoid src/ext/standard/dns.c trying to use struct __res_state:
	sed -i 's/#define HAVE_RES_NSEARCH 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
	# fix error: call to undeclared function pthread_* (https://github.com/php/php-src/blob/php-8.4.1/sapi/phpdbg/phpdbg_watch.c#L314)
	sed -i 's/#define HAVE_USERFAULTFD_WRITEFAULT 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/php-fpm.d
	cp sapi/fpm/php-fpm.conf $TERMUX_PREFIX/etc/
	cp sapi/fpm/www.conf $TERMUX_PREFIX/etc/php-fpm.d/

	docdir=$TERMUX_PREFIX/share/doc/php
	mkdir -p $docdir
	for suffix in development production; do
		cp $TERMUX_PKG_SRCDIR/php.ini-$suffix $docdir/
	done

	local extdir="$TERMUX_PREFIX/etc/$TERMUX_PKG_NAME/conf.d"
	mkdir -p "$extdir"
	for ext in gd ldap pgsql pdo_pgsql sodium; do
		echo "extension=$ext" > "$extdir/$ext.ini"
	done

	sed -i 's/SED=.*/SED=sed/' $TERMUX_PREFIX/bin/phpize

	# Shared extensions for PHP/Apache
	mkdir -p $TERMUX_PREFIX/lib/php-apache
	local f
	for f in opcache ldap pdo_pgsql pgsql sodium; do
		local so=$TERMUX_PREFIX/lib/php-apache/${f}.so
		rm -f ${so}
		cp -T $TERMUX_PREFIX/lib/php/${f}.so ${so}
		patchelf --set-rpath $TERMUX_PREFIX/libexec/apache2:$TERMUX_PREFIX/lib \
			--add-needed libphp.so \
			${so}
	done
}
