TERMUX_PKG_HOMEPAGE=https://www.sqlite.org
TERMUX_PKG_DESCRIPTION="Library implementing a self-contained and transactional SQL database engine"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.46.1"
_SQLITE_YEAR=2024
TERMUX_PKG_SRCURL=https://www.sqlite.org/${_SQLITE_YEAR}/sqlite-autoconf-$(sed 's/\./''/; s/\./0/' <<< "$TERMUX_PKG_VERSION")00.tar.gz
TERMUX_PKG_SHA256=67d3fe6d268e6eaddcae3727fce58fcc8e9c53869bdd07a0c61e38ddf2965071
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_BUILD_DEPENDS="tcl"
TERMUX_PKG_BREAKS="libsqlite-dev"
TERMUX_PKG_REPLACES="libsqlite-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-readline
--enable-fts3
"

termux_step_pre_configure() {
	CPPFLAGS+=" -Werror -DSQLITE_ENABLE_DBSTAT_VTAB=1 -DSQLITE_ENABLE_COLUMN_METADATA=1 -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1"
	LDFLAGS+=" -lm"
}

termux_step_post_make_install() {
	echo -e "termux - building libsqlite-tcl for arch ${TERMUX_ARCH}..."
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --with-tcl=${TERMUX_PREFIX}/lib --with-system-sqlite"
	TERMUX_PKG_SRCDIR+="/tea"
	rm -rf "$TERMUX_PKG_TMPDIR/config-scripts"
	termux_step_configure
	termux_step_make
	termux_step_make_install
}
