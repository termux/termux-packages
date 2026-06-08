TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	"3.53.2"
	"2026" # Release year
)
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://www.sqlite.org/${TERMUX_PKG_VERSION[1]}/sqlite-src-$(sed 's/\./''/; s/\./0/' <<< "${TERMUX_PKG_VERSION[0]}")00.zip"
TERMUX_PKG_SHA256=cafff764c03f6d720968f746e2f47a986bbf12bf4c18904f1eb131c0b0b592d3
TERMUX_PKG_DEPENDS="readline, zlib"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_BREAKS="libsqlite-dev, libsqlite"
TERMUX_PKG_REPLACES="libsqlite-dev, libsqlite"
TERMUX_PKG_AUTO_UPDATE=true
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
	CPPFLAGS+=" -Werror"
	CPPFLAGS+=" -DSQLITE_ENABLE_DBSTAT_VTAB=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_COLUMN_METADATA=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_UNLOCK_NOTIFY=1"
	CPPFLAGS+=" -DSQLITE_ENABLE_FTS3_PARENTHESIS"
	CPPFLAGS+=" -DSQLITE_ENABLE_RBU"
	CPPFLAGS+=" -DSQLITE_ENABLE_GEOPOLY"
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
	mkdir -p "$TERMUX_PKG_TMPDIR/sqlite${TERMUX_PKG_VERSION[0]}"
	make tclextension-install DESTDIR="$TERMUX_PKG_TMPDIR/sqlite${TERMUX_PKG_VERSION[0]}" OPTS="-lm"

	# Move the TCL extension files into their proper place
	find "$TERMUX_PKG_TMPDIR/sqlite${TERMUX_PKG_VERSION[0]}" -name "libsqlite${TERMUX_PKG_VERSION[0]}.so" \
		-exec install -vDm700 "{}" "${TERMUX_PREFIX}/lib/sqlite3/libtclsqlite3.so" \;
	find "$TERMUX_PKG_TMPDIR/sqlite${TERMUX_PKG_VERSION[0]}" -name pkgIndex.tcl \
		-exec install -vDm600 "{}" "${TERMUX_PREFIX}/lib/sqlite3/pkgIndex.tcl" \;
}
