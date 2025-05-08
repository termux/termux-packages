TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.49.2"
_SQLITE_YEAR=2025
TERMUX_PKG_SRCURL=https://www.sqlite.org/${_SQLITE_YEAR}/sqlite-autoconf-$(sed 's/\./''/; s/\./0/' <<< "$TERMUX_PKG_VERSION")00.tar.gz
TERMUX_PKG_SHA256=5c6d8697e8a32a1512a9be5ad2b2e7a891241c334f56f8b0fb4fc6051e1652e8
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
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1"
	LDFLAGS+=" -lm"
}

# See: https://github.com/termux/termux-packages/issues/23268#issuecomment-2685308408
termux_step_configure() {
	"$TERMUX_PKG_SRCDIR"/configure \
		--prefix="$TERMUX_PREFIX" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make_install() {
	make install INSTALL.strip=/usr/bin/install
}

termux_step_post_make_install() {
	echo -e "termux - building libsqlite-tcl for arch ${TERMUX_ARCH}..."
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-tcl=${TERMUX_PREFIX}/lib --with-system-sqlite"
	TERMUX_PKG_SRCDIR+="/tea"
	rm -rf "$TERMUX_PKG_TMPDIR/config-scripts"
	termux_step_configure_autotools
	termux_step_make
	termux_step_make_install
}
