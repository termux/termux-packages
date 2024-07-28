TERMUX_PKG_HOMEPAGE=https://gnucobol.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A free/libre COBOL compiler"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2
TERMUX_PKG_REVISION=0

TERMUX_PKG_SRCURL=git+https://github.com/alexbodn/gnucobol-3.2.git
TERMUX_PKG_GIT_BRANCH="termux"

TERMUX_INSTALL_DEPS=true

TERMUX_PKG_DEPENDS="json-c, libgmp, libdb, libxml2, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
	--with-db
	--with-json=json-c
	--with-xml2
"

termux_step_pre_configure() {
	local lp64="$(( $TERMUX_ARCH_BITS / 32 - 1 ))"
	export COB_LI_IS_LL="${lp64}"
	export COB_32_BIT_LONG="$(( 1 - ${lp64} ))"
	export COB_HAS_64_BIT_POINTER="${lp64}"
	
	export BDB_HEADER=$(cat db_header.c |cc -I$TERMUX_PREFIX/include -P -E -| tail -n 1| sed -e 's/[\ \t]//g')
}

termux_step_post_configure() {
	touch bin/cobcrun.1 cobc/cobc.1
}
