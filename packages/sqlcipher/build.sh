TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.12.0"
TERMUX_PKG_SRCURL="https://github.com/sqlcipher/sqlcipher/archive/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=151a1c618c7ae175dfd0f862a8d52e8abd4c5808d548072290e8656032bb0f12
TERMUX_PKG_DEPENDS="libedit, openssl"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
# --enable-editline --disable-readline
# prevents
# error: 'regparm' is not valid on this platform
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-tempstore=yes
--enable-editline
--disable-readline
--with-tcl=${TERMUX__PREFIX__LIB_DIR}
TCLLIBDIR=${TERMUX__PREFIX__LIB_DIR}/tcl8.6/sqlite
"

termux_step_pre_configure() {
	# CPPFLAGS and LDFLAGS as directed by README.md
	CPPFLAGS+=" -DSQLCIPHER_OMIT_LOG_DEVICE"
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
	CPPFLAGS+=" -DSQLITE_EXTRA_INIT=sqlcipher_extra_init"
	CPPFLAGS+=" -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown"
	LDFLAGS+=" -lcrypto"
}

# See: https://github.com/termux/termux-packages/issues/23268#issuecomment-2685308408
# (some packages do not accept '--rpath' or '--rpath-hack' configure arguments)
# Error: Unknown option --rpath-hack
termux_step_configure() {
	"$TERMUX_PKG_SRCDIR"/configure \
		--prefix="$TERMUX_PREFIX" \
		--libexecdir="$TERMUX_PREFIX/libexec" \
		--libdir="$TERMUX__PREFIX__LIB_DIR" \
		--includedir="$TERMUX__PREFIX__INCLUDE_DIR" \
		--sbindir="$TERMUX_PREFIX/bin" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
