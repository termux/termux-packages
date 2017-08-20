TERMUX_PKG_HOMEPAGE=https://lftp.tech/
TERMUX_PKG_DESCRIPTION="FTP/HTTP client and file transfer program"
TERMUX_PKG_VERSION=4.8.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://lftp.tech/ftp/lftp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7a2880968088b4aeec43b6b6680fef0e065e1dddcce9b409390157e9766b690f
# (1) Android has dn_expand, but lftp assumes that dn_skipname then exists, which it does not on android.
# (2) Use --with-openssl to use openssl instead of gnutls.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_dn_expand=no
--with-openssl
--with-expat=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
"
TERMUX_PKG_DEPENDS="libexpat, openssl, readline, libutil, libidn"

termux_step_pre_configure () {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-zlib=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr"
}
