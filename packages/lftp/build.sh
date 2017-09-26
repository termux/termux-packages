TERMUX_PKG_HOMEPAGE=https://lftp.tech/
TERMUX_PKG_DESCRIPTION="FTP/HTTP client and file transfer program"
TERMUX_PKG_VERSION=4.8.1
TERMUX_PKG_SHA256=e770daa5592ad21bd0b8a8915a0f4fdc2e15dec6c69e754a870ad9c18be57b27
TERMUX_PKG_SRCURL=https://lftp.tech/ftp/lftp-${TERMUX_PKG_VERSION}.tar.xz
# (1) Android has dn_expand, but lftp assumes that dn_skipname then exists, which it does not on android.
# (2) Use --with-openssl to use openssl instead of gnutls.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_dn_expand=no
--with-openssl
--with-expat=$TERMUX_PREFIX
--with-readline=$TERMUX_PREFIX
"
TERMUX_PKG_DEPENDS="libexpat, openssl, readline, libutil, libidn"
TERMUX_PKG_BUILD_DEPENDS="ncurses-dev"

termux_step_pre_configure () {
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-zlib=$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr"
}
