TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.4.2
TERMUX_PKG_SRCURL=https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=87458e0e16594b3ba6c7a1f046bc1ba783d002d35e0e7b61bb6b7bb862f362a7
TERMUX_PKG_DEPENDS="libsqlite, openssl"
TERMUX_PKG_BUILD_DEPENDS="tcl"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-tempstore=yes
--with-tcl=${TERMUX_PREFIX}/lib
TCLLIBDIR=${TERMUX_PREFIX}/lib/tcl8.6/sqlite
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
}
