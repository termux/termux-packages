TERMUX_PKG_HOMEPAGE=https://www.tcl.tk/
TERMUX_PKG_DESCRIPTION="Powerful but easy to learn dynamic programming language"
TERMUX_PKG_DEPENDS="libsqlite"
_MAJOR_VERSION=8.6
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.6
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tcl/Tcl/${TERMUX_PKG_VERSION}/tcl${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=a265409781e4b3edcc4ef822533071b34c3dc6790b893963809b9fe221befe07
TERMUX_PKG_FOLDERNAME=tcl$TERMUX_PKG_VERSION
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="tcl_cv_strtod_buggy=ok tcl_cv_strstr_unbroken=ok"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_strtod=yes tcl_cv_strtod_unbroken=ok"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_strtoul=yes tcl_cv_strtoul_unbroken=ok"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ac_cv_func_memcmp=yes ac_cv_func_memcmp_working=yes"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --mandir=$TERMUX_PREFIX/share/man --enable-man-symlinks"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --disable-rpath"

termux_step_pre_configure () {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/unix
}

termux_step_post_make_install () {
	cd $TERMUX_PREFIX/bin
	ln -f -s tclsh$_MAJOR_VERSION tclsh

	# Hack to use system libsqlite (https://www.sqlite.org/howtocompile.html#tcl)
	# since --with-system-sqlite fails to build:
	local NEW_LIBDIR=$TERMUX_PREFIX/lib/tcl$_MAJOR_VERSION/sqlite
	mkdir -p $NEW_LIBDIR
	$CC $CFLAGS $CPPFLAGS $LDFLAGS \
		-DUSE_SYSTEM_SQLITE=1 \
		-o $NEW_LIBDIR/libtclsqlite3.so \
		-shared \
		$TERMUX_PKG_SRCDIR/../../../libsqlite/src/tea/generic/tclsqlite3.c \
		-ltcl$_MAJOR_VERSION -lsqlite3
	local LIBSQLITE_VERSION=`$PKG_CONFIG --modversion sqlite3`
	echo "package ifneeded sqlite3 $LIBSQLITE_VERSION [list load [file join \$dir libtclsqlite3.so] Sqlite3]" > \
		$NEW_LIBDIR/pkgIndex.tcl
}
