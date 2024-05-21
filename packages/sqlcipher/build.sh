TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.6.0"
TERMUX_PKG_SRCURL=https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=879fb030c36bc5138029af6aa3ae3f36c28c58e920af05ac7ca78a5915b2fa3c
TERMUX_PKG_DEPENDS="libedit, openssl"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-tempstore=yes
--with-tcl=${TERMUX_PREFIX}/lib
TCLLIBDIR=${TERMUX_PREFIX}/lib/tcl8.6/sqlite
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DSQLCIPHER_OMIT_LOG_DEVICE -DSQLITE_HAS_CODEC"
}
