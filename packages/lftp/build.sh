TERMUX_PKG_HOMEPAGE=https://lftp.tech/
TERMUX_PKG_DESCRIPTION="FTP/HTTP client and file transfer program"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.9.3
TERMUX_PKG_SRCURL=http://lftp.yar.ru/ftp/lftp-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=68116cc184ab660a78a4cef323491e89909e5643b59c7b5f0a14f7c2b20e0a29
TERMUX_PKG_DEPENDS="libandroid-support, libc++, libexpat, libiconv, openssl, readline, libidn2, zlib"

# (1) Android has dn_expand, but lftp assumes that dn_skipname then exists, which it does not on android.
# (2) Use --with-openssl to use openssl instead of gnutls.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_header_glob_h=no
ac_cv_func_dn_expand=no
--with-openssl=$TERMUX_PREFIX
--with-expat=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
--with-zlib=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	CXXFLAGS+=" -DNO_INLINE_GETPASS=1"
}
