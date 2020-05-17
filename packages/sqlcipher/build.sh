TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=4.4.0
TERMUX_PKG_SRCURL=https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0924b2ae1079717954498bda78a30de20ce2a6083076b16214a711567821d148
TERMUX_PKG_DEPENDS="libsqlite, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tempstore=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
}
