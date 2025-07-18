TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.50.3"
_SQLITE_YEAR=2025
TERMUX_PKG_SRCURL=https://www.sqlite.org/${_SQLITE_YEAR}/sqlite-src-$(sed 's/\./''/; s/\./0/' <<< "$TERMUX_PKG_VERSION")00.zip
TERMUX_PKG_SHA256=119862654b36e252ac5f8add2b3d41ba03f4f387b48eb024956c36ea91012d3f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_BREAKS="libsqlite-dev"
TERMUX_PKG_REPLACES="libsqlite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-fts3
--enable-fts4
--enable-fts5
--enable-readline
--enable-rtree
--enable-session
--with-tcl=$TERMUX_PREFIX/lib
--with-tclsh=$(command -v tclsh)
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1 -DSQLITE_ENABLE_UNLOCK_NOTIFY=1"
	LDFLAGS+=" -lm"
	export TCL_CONFIG_SH="$TERMUX_PREFIX/lib/tclConfig.sh"
	export TCLLIBDIR="$TERMUX_PREFIX/lib"
}

# See: https://github.com/termux/termux-packages/issues/23268#issuecomment-2685308408
termux_step_configure() {
	"$TERMUX_PKG_SRCDIR"/configure \
		--prefix="$TERMUX_PREFIX" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make_install() {
	make install INSTALL.strip=/usr/bin/install
	mkdir -p "$TERMUX_PKG_TMPDIR/libsqlite${TERMUX_PKG_VERSION}"
	make tclextension-install DESTDIR="$TERMUX_PKG_TMPDIR/libsqlite${TERMUX_PKG_VERSION}" OPTS="-lm"

	# Move the TCL extension files into their proper place
	find "$TERMUX_PKG_TMPDIR/libsqlite${TERMUX_PKG_VERSION}" -name "libsqlite${TERMUX_PKG_VERSION}.so" \
		-exec install -vDm700 "{}" "${TERMUX_PREFIX}/lib/sqlite3/libtclsqlite3.so" \;
	find "$TERMUX_PKG_TMPDIR/libsqlite${TERMUX_PKG_VERSION}" -name pkgIndex.tcl \
		-exec install -vDm600 "{}" "${TERMUX_PREFIX}/lib/sqlite3/pkgIndex.tcl" \;

	# Remove duplicates
	rm "$TERMUX_PREFIX/lib"/{pkgIndex.tcl,libtclsqlite3.so}
}
