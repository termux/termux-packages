TERMUX_PKG_HOMEPAGE=http://php.net/
TERMUX_PKG_DESCRIPTION="Server-side, HTML-embedded scripting language"
TERMUX_PKG_VERSION=5.6.20
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://php.net/get/php-${TERMUX_PKG_VERSION}.tar.xz/from/this/mirror
TERMUX_PKG_NO_SRC_CACHE=yes # Caching with filename does not work for 'mirror'
# Build native php for phar to build (see pear-Makefile.frag.patch):
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_FOLDERNAME=php-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libandroid-glob, libxml2, liblzma, openssl, pcre, libcrypt"
# http://php.net/manual/en/libxml.installation.php
# "If configure cannot find xml2-config in the directory specified by --with-libxml-dir,
# then it'll continue on and check the default locations."
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-libxml-dir=$TERMUX_PREFIX"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-openssl=$TERMUX_PREFIX"
# http://php.net/manual/en/pcre.installation.php: pcre always enabled, use platform library:
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-pcre-regex=$TERMUX_PREFIX"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-iconv=$TERMUX_PREFIX"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-zip"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_res_nsearch=no"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-sockets"

LDFLAGS+=" -landroid-glob"

termux_step_pre_configure () {
	export PATH=$PATH:$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/
	export NATIVE_PHP_EXECUTABLE=$TERMUX_PKG_HOSTBUILD_DIR/sapi/cli/php

	# Run autoconf since we have patched config.m4 files.
	cd $TERMUX_PKG_SRCDIR
	autoconf
}

termux_step_post_configure () {
	perl -p -i -e 's/#define HAVE_RES_NSEARCH 1//' $TERMUX_PKG_BUILDDIR/main/php_config.h
}
