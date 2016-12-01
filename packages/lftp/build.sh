TERMUX_PKG_HOMEPAGE=https://lftp.tech/
TERMUX_PKG_DESCRIPTION="FTP/HTTP client and file transfer program"
TERMUX_PKG_VERSION=4.7.4
TERMUX_PKG_SRCURL=https://lftp.tech/ftp/lftp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bf67c4d128b6f769a4082947376a9679c5ee3463a24ab761a0757f75d70bd92c
# (1) Android has dn_expand, but lftp assumes that dn_skipname then exists, which it does not on android.
# (2) Use --with-openssl to use openssl instead of gnutls.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_dn_expand=no --with-openssl --with-expat=$TERMUX_PREFIX"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-readline=$TERMUX_PREFIX"
TERMUX_PKG_DEPENDS="libexpat, openssl, readline, libutil, libidn"

termux_step_pre_configure () {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-zlib=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr"

	# We have patched an m4 file.
	cd $TERMUX_PKG_SRCDIR
	aclocal
	autoconf
}
