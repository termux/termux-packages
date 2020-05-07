TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_SRCURL=https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fccb37e440ada898902b294d02cde7af9e8706b185d77ed9f6f4d5b18b4c305f
TERMUX_PKG_DEPENDS="libsqlite, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-tempstore=yes"

termux_step_pre_configure() {
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
}
