TERMUX_PKG_HOMEPAGE=https://gnucobol.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A free/libre COBOL compiler"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_REVISION=3
##TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/gnucobol/gnucobol-${TERMUX_PKG_VERSION}.tar.xz
##TERMUX_PKG_SHA256=3bb48af46ced4779facf41fdc2ee60e4ccb86eaa99d010b36685315df39c2ee2
TERMUX_PKG_SRCURL=git+https://github.com/alexbodn/gnucobol-3.2.git
#TERMUX_PKG_SHA256=bcdc555d76cbc951bb51d66f1cae5e92bf5bcb5349d0330f5c58f5954e62c8c3
TERMUX_PKG_GIT_BRANCH="termux"
TERMUX_INSTALL_DEPS=true

#TERMUX_PKG_DEPENDS="json-c, libgmp, libdb, libxml2, ncurses"

TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686, x86_64"
TERMUX_PKG_DEPENDS="libgmp, libdb, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-db
"
##--with-json=json-c
##--with-xml2

termux_step_pre_configure() {
	local lp64="$(( $TERMUX_ARCH_BITS / 32 - 1 ))"
	export COB_LI_IS_LL="${lp64}"
	export COB_32_BIT_LONG="$(( 1 - ${lp64} ))"
	export COB_HAS_64_BIT_POINTER="${lp64}"
	
#	export BDB_LIBS="-ldb"
#	export BDB_CFLAGS="-DWITH_DB=1"
#	export LIBCOB_CPPFLAGS="-DWITH_DB=1"
#	export COBC_CPPFLAGS="-DWITH_DB=1"
	export BDB_HEADER=$(cat db_header.c |cc -P -E -| tail -n 1| sed -e 's/[\ \t]//g')
	cat db_header.c
	echo $BDB_HEADER
##	export BDB_HEADER="18.1"

#	echo '#ifdef WITH_DB' >> config.h.in
#	echo '#undef WITH_DB' >> config.h.in
#	echo '#endif /*WITH_DB*/' >> config.h.in
#	echo '#define WITH_DB 1' >> config.h.in
	#echo "==================="
	#cat config.h
	#echo "==================="
}

termux_step_post_configure() {
#	echo "==================="
#	cat config.log
#	echo $DEFS
#	echo $CFLAGS
#	find -name confdefs.h
#	echo "==================="
	touch bin/cobcrun.1 cobc/cobc.1
}
