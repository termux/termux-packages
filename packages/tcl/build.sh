TERMUX_PKG_HOMEPAGE=https://www.tcl.tk/
TERMUX_PKG_DESCRIPTION="Powerful but easy to learn dynamic programming language"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="license.terms"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=8.6.10
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/tcl/Tcl/${TERMUX_PKG_VERSION}/tcl${TERMUX_PKG_VERSION}-src.tar.gz
TERMUX_PKG_SHA256=5196dbf6638e3df8d5c87b5815c8c2b758496eb6f0e41446596c9a4e638d87ed
TERMUX_PKG_DEPENDS="libsqlite, zlib"
TERMUX_PKG_BREAKS="tcl-dev, tcl-static"
TERMUX_PKG_REPLACES="tcl-dev, tcl-static"
TERMUX_PKG_NO_STATICSPLIT=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_memcmp_working=yes
ac_cv_func_memcmp=yes
ac_cv_func_strtod=yes
ac_cv_func_strtoul=yes
tcl_cv_strstr_unbroken=ok
tcl_cv_strtod_buggy=ok
tcl_cv_strtod_unbroken=ok
tcl_cv_strtoul_unbroken=ok
--disable-rpath
--enable-man-symlinks
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/unix
	CFLAGS+=" -DBIONIC_IOCTL_NO_SIGNEDNESS_OVERLOAD"
}

termux_step_post_make_install() {
	# expect needs private headers
	make install-private-headers
	local _MAJOR_VERSION=${TERMUX_PKG_VERSION:0:3}
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
		$TERMUX_PREFIX/src/libsqlite/tclsqlite3.c \
		-ltcl$_MAJOR_VERSION -lsqlite3
	local LIBSQLITE_VERSION=$($PKG_CONFIG --modversion sqlite3)
	echo "package ifneeded sqlite3 $LIBSQLITE_VERSION [list load [file join \$dir libtclsqlite3.so] Sqlite3]" > \
		$NEW_LIBDIR/pkgIndex.tcl

	# Needed to install $TERMUX_PKG_LICENSE_FILE.
	TERMUX_PKG_SRCDIR=$(dirname "$TERMUX_PKG_SRCDIR")

	#avoid conflict with perl
	mv $TERMUX_PREFIX/share/man/man3/Thread.3 $TERMUX_PREFIX/share/man/man3/Tcl_Thread.3
}
