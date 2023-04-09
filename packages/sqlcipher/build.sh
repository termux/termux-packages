TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.5.3"
TERMUX_PKG_SRCURL=https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5c9d672eba6be4d05a9a8170f70170e537ae735a09c3de444a8ad629b595d5e2
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-tempstore=yes
--with-tcl=${TERMUX_PREFIX}/lib
TCLLIBDIR=${TERMUX_PREFIX}/lib/tcl8.6/sqlite
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
}
