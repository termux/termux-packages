TERMUX_PKG_HOMEPAGE=https://github.com/sqlcipher/sqlcipher
TERMUX_PKG_DESCRIPTION="SQLCipher is an SQLite extension that provides 256 bit AES encryption of database files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.16.0"
TERMUX_PKG_SRCURL="https://github.com/sqlcipher/sqlcipher/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d687bf981199ac019c6c87b11f92a5900aec777855e7ba5b30e5e1192933ce8a
TERMUX_PKG_DEPENDS="libedit, openssl"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
# will overwrite libsqlite during installation
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
# --enable-editline --disable-readline
# prevents
# error: 'regparm' is not valid on this platform
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-tempstore=yes
--enable-editline
--disable-readline
--enable-fts3
--enable-fts4
--enable-fts5
--enable-rtree
--enable-session
--with-tcl=${TERMUX__PREFIX__LIB_DIR}
TCLLIBDIR=${TERMUX__PREFIX__LIB_DIR}/tcl8.6/sqlite
"

termux_step_pre_configure() {
	# CPPFLAGS and LDFLAGS as directed by README.md
	# and also by the termux-packages libsqlite package so that sqlcipher
	# can be built after libsqlite but before packages that depend on libsqlite
	# and provide the exact same symbols as libsqlite
	# in a single docker container building many packages
	CPPFLAGS+=" -DSQLCIPHER_OMIT_LOG_DEVICE"
	CPPFLAGS+=" -DSQLITE_HAS_CODEC"
	CPPFLAGS+=" -DSQLITE_EXTRA_INIT=sqlcipher_extra_init"
	CPPFLAGS+=" -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown"
	CPPFLAGS+=" -DSQLITE_ENABLE_DBSTAT_VTAB=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_COLUMN_METADATA=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_UNLOCK_NOTIFY=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_FTS3_PARENTHESIS"
	CPPFLAGS+=" -DSQLITE_ENABLE_RBU"
	CPPFLAGS+=" -DSQLITE_ENABLE_GEOPOLY"
	LDFLAGS+=" -lcrypto"
	LDFLAGS+=" -lm"
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
		--disable-static \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_massage() {
	# Rename files from sqlite3 to sqlcipher to prevent file collisons
	# based on the precedent being set by LigurOS, NixOS
	# https://gitlab.com/liguros/liguros-repo/-/blob/2406209f428ab349fc33209834caf1a7a0477fda/dev-db/sqlcipher/sqlcipher-4.12.0.ebuild#L70
	local sql_version="$(cat "$TERMUX_PKG_SRCDIR"/VERSION)"
	mv bin/{sqlite3,sqlcipher}
	mv include/{sqlite3,sqlcipher}.h
	mv include/{sqlite3ext,sqlcipherext}.h
	mv lib/lib{sqlite3,sqlcipher}.so
	mv lib/lib{sqlite3,sqlcipher}.so.0
	mv lib/lib{sqlite3,sqlcipher}.so."$sql_version"
	mv lib/pkgconfig/{sqlite3,sqlcipher}.pc
	mv share/man/man1/{sqlite3,sqlcipher}.1.gz
	sed -i s/-lsqlite3/-lsqlcipher/ lib/pkgconfig/sqlcipher.pc
}
