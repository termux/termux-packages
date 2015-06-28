TERMUX_PKG_HOMEPAGE=http://lftp.yar.ru/
TERMUX_PKG_DESCRIPTION="FTP/HTTP client and file transfer program"
TERMUX_PKG_VERSION=4.6.3a
TERMUX_PKG_SRCURL=http://lftp.yar.ru/ftp/lftp-${TERMUX_PKG_VERSION}.tar.xz
# (1) Android has dn_expand, but lftp assumes that dn_skipname then exists, which it does not on android.
# (2) Use --with-openssl to use openssl instead of gnutls.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_func_dn_expand=no --with-openssl"
TERMUX_PKG_DEPENDS="libexpat, openssl, readline"
