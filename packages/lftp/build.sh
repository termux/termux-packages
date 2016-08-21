TERMUX_PKG_HOMEPAGE=http://lftp.yar.ru/
TERMUX_PKG_DESCRIPTION="FTP/HTTP client and file transfer program"
TERMUX_PKG_VERSION=4.7.3
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=http://lftp.yar.ru/ftp/lftp-${TERMUX_PKG_VERSION}.tar.xz
# (1) Android has dn_expand, but lftp assumes that dn_skipname then exists, which it does not on android.
# (2) Use --with-openssl to use openssl instead of gnutls.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_dn_expand=no --with-openssl --with-zlib=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr --with-expat=$TERMUX_PREFIX"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-readline=$TERMUX_PREFIX"
TERMUX_PKG_DEPENDS="libexpat, openssl, readline, libutil, libidn"

termux_step_pre_configure () {
	# We have patched an m4 file.
	cd $TERMUX_PKG_SRCDIR
        aclocal
	autoconf
}
