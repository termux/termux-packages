TERMUX_PKG_HOMEPAGE=https://www.oracle.com/database/berkeley-db
TERMUX_PKG_DESCRIPTION="The Berkeley DB embedded database system (library) last non AGPL"
TERMUX_PKG_LICENSE=Sleepycat
#TERMUX_PKG_LICENSE="custom"
# We override TERMUX_PKG_SRCDIR termux_step_pre_configure so need to do
# this hack to be able to find the license file.
TERMUX_PKG_LICENSE_FILE="../LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.19
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.oracle.com/berkeley-db/db-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2917c28f60903908c2ca4587ded1363b812c4e830a5326aaa77c9879d13ae18e
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_CONFLICTS="libdb-dev,libdb"
TERMUX_PKG_REPLACES="libdb-dev,libdb"
TERMUX_PKG_PROVIDES="libdb"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	--enable-compat185 \
	--enable-shared \
	--enable-static \
	--disable-rpath \
	--enable-cxx \
	--with-tcl=no \
	--disable-sql \
	--disable-sql-codegen \
	--disable-stl \
	--disable-dbm \
	--disable-tcl \
	--disable-replication \
	--docdir=$TERMUX_PKG_SRCDIR/share/doc/libdb6
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/dist

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}