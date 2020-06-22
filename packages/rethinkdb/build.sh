TERMUX_PKG_HOMEPAGE=https://www.rethinkdb.com/
TERMUX_PKG_DESCRIPTION="The open-source database for the realtime web. "
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_LICENSE_FILE="COPYRIGHT"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_SRCURL=https://github.com/rethinkdb/rethinkdb/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e3749b644af0b230685a32ef31317a9dfebfee5582ded47c444c1c0eaa83712e
TERMUX_PKG_DEPENDS="ncurses, libcurl, openssl, libcrypt, python, protobuf, libprotobuf-c, nodejs"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"

TERMUX_MAKE_PROCESSES=1

termux_step_configure() {
	termux_setup_protobuf

	./configure --prefix $TERMUX_PREFIX \
		--sysconfdir $TERMUX_PREFIX/etc \
		--localstatedir $TERMUX_PREFIX/var \
		--fetch coffee \
		--fetch boost \
		--fetch browserify \
		--with-system-malloc \
		CXXFLAGS="$CXXFLAGS $CPPFLAGS" LDFLAGS="$LDFLAGS"
}

termux_step_make() {
	make fetch
	sed -i 's/python/python2/' ./external/v8_3.30.33.16-patched/build/gyp/gyp
	make
}
