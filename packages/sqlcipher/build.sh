TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=4.4.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a36ed7c879a5e9af1054942201c75fc56f1db22e46bf6c2bbae3975dfeb6782d
TERMUX_PKG_DEPENDS="libsqlite, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tempstore=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
}
